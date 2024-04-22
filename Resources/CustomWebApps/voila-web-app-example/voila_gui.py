import os
from urllib.parse import parse_qs
from time import sleep

import ipywidgets as widgets

import plotly.graph_objects as go
from modelon.impact.client import Client


def get_query_param(param, fallback):
    query_string = os.environ.get("QUERY_STRING", "")
    parameters = parse_qs(query_string)
    return parameters.get(param, [fallback])[0]


default_workspace = "impactvoilaappexample"
default_model = "ElectricRange.Experiments.Range2"


class VoilaGUI:
    def __init__(self):
        self.client = Client()
        self.workspace = self.client.get_workspace(
            get_query_param("workspaceid", default_workspace)
        )
        self.model = self.workspace.get_model(get_query_param("model", default_model))
        self.dynamic = self.workspace.get_custom_function("dynamic")

        self.batteries = [
            ("Battery A", ".ElectricRange.Batteries.BatteryA"),
            ("Battery B", ".ElectricRange.Batteries.BatteryB"),
        ]

        self.battery_dropdown = widgets.Dropdown(
            options=self.batteries,
            description="Battery:",
        )

        self.label = widgets.Label(
            f"Workspace: {self.workspace.name}, Model:{self.model.name}"
        )

        self.parameter_input = widgets.BoundedFloatText(
            value=2000,
            min=1000,
            max=4000,
            step=50,
            description="Vehicle Mass [kg]:",
            disabled=False,
        )
        self.parameter_input.key = "chassis.vehicle_mass"
        self.parameter_input.style.description_width = "auto"

        self.button = widgets.Button(description="Simulate")

        self.widget_list = [self.label, self.parameter_input, self.button]
        self.hbox_layout = widgets.Layout(
            display="flex",
            flex_flow="row",
            justify_content="space-around",
            width="100%",
        )
        self.hbox = widgets.HBox(self.widget_list, layout=self.hbox_layout)
        self.plot_output = widgets.Output()

    def start(self):
        self._display_widgets([self.hbox, self.plot_output])
        self.fig = self._init_plot()
        self.button.on_click(self._on_simulate)

    def _display_widgets(self, widgets):
        for w in widgets:
            display(w)  # noqa: F821

    def _get_battery_redeclare_string(self):
        return f"(redeclare replaceable {self.battery_dropdown.value} batteryPack)"

    def _read_parameter_values(self):
        return {self.parameter_input.key: self.parameter_input.value}

    def _get_current_case_label(self):
        return f"{self.battery_dropdown.label}, Mass: {self.parameter_input.value}"

    def _get_experiment_definition(self):
        redeclare_string = self._get_battery_redeclare_string()
        model_with_redeclare = self.workspace.get_model(
            self.model.name + redeclare_string
        )
        modifiers = self._read_parameter_values()
        experiment_definition_base = model_with_redeclare.new_experiment_definition(
            self.dynamic.with_parameters(start_time=0, final_time=36000)
        )
        experiment_definition = experiment_definition_base.with_modifiers(modifiers)
        return experiment_definition

    def _run_experiment(self):
        self.button.disabled = True
        button_text_init_value = self.button.description

        experiment_definition = self._get_experiment_definition()
        operation = self.workspace.execute(experiment_definition)

        while not operation.is_complete():
            self.button.description = f"{operation.status.value}..."
            sleep(0.5)
        self.button.description = button_text_init_value
        self.button.disabled = False

        experiment = operation.data()
        return experiment

    def _on_simulate(self, button):
        case_name = self._get_current_case_label()
        experiment = self._run_experiment()
        case = experiment.get_cases()[0]
        res = case.get_trajectories()
        res_variable_names = ["time", case_name]
        res_variable_keys = ["time", "batteryPack.summary.SoC"]
        data = {
            name: res[key] for name, key in zip(res_variable_names, res_variable_keys)
        }
        self._add_trace_to_plot(data, x="time", y=case_name)

    def _init_plot(self):
        fig = go.Figure()
        fig.update_layout(
            xaxis_title="Time [s]",
            yaxis_title="SOC []",
            title="Battery SOC",
            showlegend=True,
        )

        with self.plot_output:
            self.plot_output.clear_output(wait=True)
            fig.show()

        return fig

    def _add_trace_to_plot(self, data, x, y):
        self.fig.add_trace(go.Scatter(x=data[x], y=data[y], mode="lines", name=y))
        with self.plot_output:
            self.plot_output.clear_output(wait=True)
            self.fig.show()
