# impact-voila-app-example

This is a small sample project that serves a demonstrator on how to build a voila app in Modelon Impact.

## Getting started

To get access to the apps:

- Check out the project using the project explorer
- Open a workspace containing the project
- You should now be able to access all apps from the apps menu (some of them requires having a model selected).

## Examples

There are 4 examples in this repo:

- [voila-hello-world](./Resources/CustomWebApps/voila-hello-world/): Simplest possible voila app to get started.
- [voila-minimal](./Resources/CustomWebApps/voila-minimal/): Minimal user interface with Jupyter Widgets, Plotly and the Modelon Impact Client libraries.
- [voila-basic-gui](./Resources/CustomWebApps/voila-basic-ui/): Shows how Jupyter Widgets, Plotly and the Modelon Impact Client libraries can be leveraged to create a basic UI.
- [voila-external-dependency](./Resources/CustomWebApps/voila-external-dependency/): Shows how external dependencies can be added to an application.
- [voila-custom-experiment-gui](./Resources/CustomWebApps/voila-custom-experiment-gui/): A custom user interface for experiments and analysis (parameter dialog, redeclares, experiment control, comparing results, export, ...).

## Best Practices

- Version controlling a .ipynb is difficult since cell output is stored in the .ipynb file. Keep the bulk of your code in a separate python file.
- Alternatively [jupytext](https://jupytext.readthedocs.io/en/latest/) can be used to keep notebook output out of version control.

## Additional resources

- [Plotly tutorials on interactivity](https://plotly.com/python/chart-events/) - Tutorials that shows how to add interactivity to plotly graphs, spefically in jupyter notebooks.
- [Jupyter widgets documentation](https://ipywidgets.readthedocs.io/en/stable/) - Documentation and widget lists from jupyter widgets (ipywidgets).
- [Modelon Impact Client documentation](https://modelon-impact-client.readthedocs.io/en/latest/) - The python client library for easy scripting against Modelon Impact.
