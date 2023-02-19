# Background information on: paramGUI
This readme provides some additional information about the application used for pyglotaran cross-validation, how it works and how it was used to generate validation-data.

## What is it?
paramGUI is an R-package for teaching parameter estimation examples inspired by time-resolved spectroscopy. It is based on the Shiny framework and consists of an interactive graphical user interface (GUI) that can be used to explore various parameter estimation examples.

## How does it work?
In the GUI students can simulate data while controlling a limited number of variables (Simulate), model and fit data (Fitting), as well as load and save data (I/O).

![paramGUI side menu](screenshots/paramGUI-sc01.png "A side-by-side view of the three different states of the sidepanel menu in paramGUI: Simulate, Fitting and I/O")

The main window features 4 primary tabs to explore data (Data), visualize the optimization process (Fit progression), visualize the optimization results (Fit results) and explore the statistical significance of the fitted results (Diagnostics).

The first of those tabs (Data) typically shows 4 plots. From left to right, the first of those plots, labeled `Data`, shows a 2D intensity map of the (simulated) dataset, with time on the horizontal axis, and wavelength on the vertical axis. The second plot, labeled `log(sing val. data)` shows a logarithmic plot of the singular values of the Singular Value Decomposition (SVD). The third plot, labeled `1st LSV data`, shows the first left singular vector of the SVD of the Data, which depicts the magnitude along the time axis. And finally the fourth plot, labeled `1st RSV data`, shows the first right singular vector of the SVD of the data, which depicts the magnitude along the spectral axis.

![paramGUI data plot](screenshots/paramGUI-sc02-data.png "A render of the data plot view in paramGUI showing: Data, log(sing val. data), 1st LSV data, 1st RSV data")

The tab Fit progression, shows the raw output of the minimizer. On each iteration it prints the residual,

```console
0.3201847   (3.32e-03): par = (0.055 0.005)
  It.   1, fac=           1, eval (no.,total): ( 1,  1): new dev = 0.320181
0.3201812   (6.33e-06): par = (0.05503539 0.00500788)
```

## How was it used to generate validation data?
The default example which a paramGUI session starts with consists of


### Validation set 01

### Validation set 02

### Validation set 03

### Validation set 04


