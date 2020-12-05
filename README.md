# fedora-sc
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/gitbucket/gitbucket/blob/master/LICENSE)

A prebuilt cjr stack for scientific computing that is based on Fedora 32.

## Description

This stack provides basic support for the following packages:

1. **Languages**
   - Python 3
   - c, c++
   - Fortran
   - Julia
   - R
   - Latex
2. **Libraries**
   - Matplotlib
   - Ray
   - BLAS, LAPACK
   - OPENMPI, mpi4py
   - X11
3. **Dev Environments**
   - Jupyter notebook, Jupyter lab
   - Theia
   - VS Code (through vnc)
   - vim, git, vim, emacs, tmux
4. **Additional Software**
   - tigervnc

The configurations for Jupyter, Theia, VSCode, and Tigervnc are respectively stored the directories `config/jupyter`, `config/theia`, `config/vscode`,  and `config/vnc` which are bound to `~/.jupyter`, `~/.theia`, `~/.vscode`, and `~/.vnc` in the container.
The stack comes preconfigured with Theia extensions for python, c/c++ and Fortran.

When building, the image modifies the default container user so that id and group id match with the host.

## Installation

To use use this stack with cjr simply run the command
```console
cjr stack:pull https://github.com/container-job-runner/fedora-sc.git
```
You can then build the stack by running
```console
cjr stack:build fedora-sc
```
To run an interactive shell with this stack run
```console
cjr shell --stack=fedora-sc
```