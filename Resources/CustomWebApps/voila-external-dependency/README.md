# voila-external-dependency

## Usage

This app shows how to add an external dependency. 

From this directory we can run (or from the notebook itself):

```sh
make install
```

To install app dependencies before sharing. 

Please see `Makefile` for install recipe. Requirements are saved in requirements.txt

## Background

The procedure in short:
- Create a requirements.txt file with your dependencies
    - Versions of packages should be frozen to avoid installing new versions.
    - If upgrade is needed, the installs folder should be removed first.
- Freeze current versions of installed packages into a file `constraints.txt`.
- Install using flags:
    - `-r requirements.txt`: Installs packages listed in the given file.
    - `--no-deps`: This will make sure no dependencies to the given packages are installed. Any dependencies not already installed needs to be added to requirements as well. If this would not be there, dependencies from `constraints.txt` would be installed also, even though that would be unnecessary as they already exists in the environment.
    - `-c constraints.txt`: This will make sure that we do not override anything from the current runtime environment.
    - `--target <install-dir>`: Installs to specific directory. This directory can be added to path in your .ipynb or .py-files using:

```py
import sys
sys.path.append('<install-dir>')
```

See the [`pip install` documentation](https://pip.pypa.io/en/stable/cli/pip_install/) for more info.

A common practice is to use virtual environments to isolate the python runtime environment. For Voila apps deployed on impact this is not convenient for a couple of reasons:

- In notebooks, virtual environments are used by creating a kernel for it. Kernels are not easily installed on the receiver's end. Another side effect would also be that the installed kernel would show up in the user's JupyterLab. 
- Currently OCT packages can not be included conveniently when creating a new virtual environment.

Therefore currently the best way of adding dependencies to your Voila app is to install the dependencies locally in the app folder and shipping it with the workspace including the app. I.e. it is important that dependencies has been installed before sharing a workspace with the app to consumers. 