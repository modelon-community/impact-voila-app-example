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


# Set default workspace and model (mainly for development purposes)
default_workspace = "custom-app-demo"
default_model = "Modelica.Blocks.Examples.PID_Controller"


class VoilaGUI:
    def __init__(self):
        # Init client
        self.client = Client()

        # Workspace label
        label_identifier_layout = widgets.Layout(
            display="flex", width="80px", justify_content="flex-end"
        )
        self.workspace = self.client.get_workspace(
            get_query_param("workspaceid", default_workspace)
        )
        self.workspace_label_widget = widgets.HBox(
            [
                widgets.Label("Workspace:", layout=label_identifier_layout),
                widgets.Label(f"{self.workspace.name}"),
            ]
        )

        # Init custom function
        self.custom_function = self.workspace.get_custom_function("dynamic")

        # Model label
        self.model = self.workspace.get_model(get_query_param("model", default_model))
        self.model_label_widget = widgets.HBox(
            [
                widgets.Label("Model:", layout=label_identifier_layout),
                widgets.Label(f"{self.model.name}"),
            ]
        )

        # Experiment input
        self.start_time_input = widgets.FloatText(
            description="Start time:",
            value=0,
            disabled=False,
        )
        self.final_time_input = widgets.FloatText(
            description="Final time:",
            value=1,
            disabled=False,
        )
        self.experiment_input_widget = widgets.VBox(
            [self.start_time_input, self.final_time_input]
        )

        # Init experiments
        self.experiments = []

        # Parameter selector
        self.parameters = self._get_parameters()
        has_parameters = len(self.parameters) > 0
        self.parameter_selector = widgets.Combobox(
            options=self.parameters,
            description="Parameter:",
            placeholder=(
                "Select parameter" if has_parameters else "No parameters available"
            ),
            ensure_option=True,
            disabled=not has_parameters,
        )
        self.parameter_selector.observe(self._on_parameter_select)
        self.parameter_input = widgets.FloatSlider(
            step=0.1,
            disabled=True,
            continuous_update=False,
            orientation="horizontal",
            readout=True,
            readout_format=".1f",
        )
        self.parameter_widget = widgets.HBox(
            [self.parameter_selector, self.parameter_input]
        )

        # Simulate button
        self.simulate_button = widgets.Button(description="Simulate", disabled=True)
        self.simulate_button.on_click(self._on_simulate)

        # Plot variable selector
        self.variable_selector_widget = widgets.Combobox(
            options=[],
            description="Plot variable:",
            placeholder=("Run experiment"),
            disabled=True,
        )
        self.variable_selector_widget.observe(self._on_variable_select, names="value")

        # Init plot
        self.fig = go.FigureWidget(
            data=[],
            layout=go.Layout(title={"text": "Plot"}, xaxis={"title": "Time [s]"}),
        )
        self.fig.data
        self.widgets = [
            self.workspace_label_widget,
            self.model_label_widget,
            self.experiment_input_widget,
            self.parameter_widget,
            self.variable_selector_widget,
            self.simulate_button,
            self.fig,
        ]

    def start(self):
        self._display_widgets(self.widgets)

    def _display_widgets(self, widgets):
        for w in widgets:
            display(w)  # noqa: F821

    def _get_parameters(self):
        baseline_experiment = self._get_baseline_experiment()
        fmu = baseline_experiment.get_cases()[0].get_fmu()
        return (
            [p for p in fmu.get_settable_parameters() if not p.startswith("_")]
            if fmu
            else []
        )

    def _on_parameter_select(self, change):
        baseline_experiment = self._get_baseline_experiment()
        res = baseline_experiment.get_cases()[0].get_trajectories()
        default_value = res[change.get("new", {}).get("value")][0]
        if default_value:
            self.parameter_input.value = default_value
            self.parameter_input.min = default_value * 0.5
            self.parameter_input.max = default_value * 1.5
            self.parameter_input.disabled = False
        self.simulate_button.disabled = False

    def _get_baseline_experiment(self):
        experiments = self.workspace.get_experiments()
        for e in experiments:
            if e.get_class_name() == self.model.name and e.is_successful():
                return e

        model = self.workspace.get_model(self.model.name)
        dynamic = self.workspace.get_custom_function("dynamic")
        experiment_definition = model.new_experiment_definition(dynamic)
        experiment = self.workspace.execute(experiment_definition).wait()
        return experiment

    def _on_simulate(self, button):
        experiment_label = self._get_current_experiment_label()
        experiment = self._run_experiment()
        experiment.set_label(experiment_label)
        if len(self.experiments) == 0:
            self._update_variable_selector(experiment)
        self.experiments.append(experiment)
        self._add_trace_to_plot(experiment)

    def _get_current_experiment_label(self):
        return (
            f"{self.parameter_selector.value.split('.')[-1]}: "
            f"{self.parameter_input.value}"
        )

    def _run_experiment(self):
        self.simulate_button.disabled = True
        button_text_init_value = self.simulate_button.description

        experiment_definition = self._get_experiment_definition()
        operation = self.workspace.execute(experiment_definition)

        while not operation.is_complete():
            self.simulate_button.description = f"{operation.status.value}..."
            sleep(0.5)
        self.simulate_button.description = button_text_init_value
        self.simulate_button.disabled = False

        experiment = operation.data()
        return experiment

    def _get_experiment_definition(self):
        modifiers = self._read_parameter_values()
        experiment_definition_base = self.model.new_experiment_definition(
            self.custom_function.with_parameters(
                start_time=self.start_time_input.value,
                final_time=self.final_time_input.value,
            )
        )
        experiment_definition = experiment_definition_base.with_modifiers(modifiers)
        return experiment_definition

    def _read_parameter_values(self):
        return {self.parameter_selector.value: self.parameter_input.value}

    def _update_variable_selector(self, experiment):
        variables = experiment.get_variables()
        if len(variables) > 0:
            self.variable_selector_widget.options = variables
            self.variable_selector_widget.ensure_option = True
            self.variable_selector_widget.placeholder = "Select a variable to plot"
            self.variable_selector_widget.disabled = False

    def _add_trace_to_plot(self, experiment):
        variable = self.variable_selector_widget.value
        trace = self._get_trace(experiment, variable, name=experiment.metadata.label)
        self.fig.add_trace(trace)

    def _get_trace(self, experiment, variable, name):
        case = experiment.get_cases()[0]
        res = case.get_trajectories()
        x = res["time"] if "time" in res.keys() else []
        y = res[variable] if variable in res.keys() else []
        return go.Scatter(x=x, y=y, mode="lines", name=name)

    def _update_plot(self, variable):
        with self.fig.batch_update():
            self.fig.layout.yaxis.title = variable
            for i, experiment in enumerate(self.experiments):
                case = experiment.get_cases()[0]
                res = case.get_trajectories()
                self.fig.data[i].y = res[variable] if variable in res.keys() else []

    def _on_variable_select(self, change):
        self._update_plot(variable=change.new)
