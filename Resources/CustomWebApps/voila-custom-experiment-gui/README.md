# voila-custom-experiment-gui

This app demonstrates a custom user interface for running experiments and analyzing results.

## Features
The app demonstrates the following features:
- Parameters
  - Dialog with parameters
  - Replaceable components
- Simulation
  - Length and stepsize
  - Name a simulation
  - Progress
  - Abort
  - Error log
- Results
  - List existing
  - Remove
  - Download as CSV
- Plotting
  - Select variables from a list
  - Select results to plot and compare
  - Legend with simulation names
- Shared workspace: Check for updates

## Model
By default, the app is configured for the following experiment in Electrification Library:  
`Electrification.Batteries.Experiments.Verification.StaticDischarge`  

But most of the app is general. It can be customized for use with any model.

## Dependencies
- [Plotly](https://plotly.com/python/)
- [Jupyter Widgets](https://ipywidgets.readthedocs.io/en/stable/)
- [Modelon Impact Client](https://modelon-impact-client.readthedocs.io/en/latest/)
- [Electrification Library](https://help.modelon.com/latest/library_documentation/users_guide/electrification/introduction/)
