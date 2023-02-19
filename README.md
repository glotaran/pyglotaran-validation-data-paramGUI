# pyglotaran-validation
This repository holds scripts for cross-validation of pyglotaran against paramGUI

## What is paramGUI?
paramGUI is an R-package for teaching parameter estimation examples inspired by time-resolved spectroscopy. It is based on the Shiny framework and consists of an interactive graphical user interface (GUI) that can be used to explore various parameter estimation examples.

In the GUI students can simulate data while controlling a limited number of variables (Simulate), model and fit data (Fitting), as well as load and save data (I/O).


![paramGUI side menu](screenshots/paramGUI-sc01.png "paramGUI showing the three different states of the side menu")

The main window features 4 primary windows to explore data (Data), visualize the optimization process (Fit progression), visualize the optimization results (Fit results) and explore the statistical significance of the fitted results (Diagnostics).

## Comparison
The default example which a paramGUI session starts with consists of
