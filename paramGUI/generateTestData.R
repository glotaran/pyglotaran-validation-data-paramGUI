## If the R package TIMP is not installed, please run:
## install.packages("TIMP")
## If the R package paramGUI is not installed, please run:
## install.packages("paramGUI")
initial_wd <- getwd()
print(paste('initial workdir (initial_wd): ', initial_wd))

# load packages
require(TIMP)
require(paramGUI) 
# set random seed (and noise level)
set.seed(123)
global_sigma <- .001

# Define a basic simulation function
# making use of existing simndecay function from TIMP or paramGUI
# (which has some built-in limitations)
simulateAndExportDatasetParamGUI <- function(filename, ...) {
  # dataset <- TIMP::simndecay_gen(...)
  dataset <- paramGUI::simndecay_gen_paramGUI(...)
  cat("filename\n",file=filename)
  cat("dataset name\n",file=filename,append=TRUE)
  cat("Wavelength explicit\n",file=filename,append=TRUE)
  cat("Intervalnr ",  length(dataset@x2),"\n",file=filename,append=TRUE)
  suppressWarnings(
    write.table(
      x = dataset@psi.df,
      col.names = dataset@x2,
      row.names = dataset@x,
      sep = " ",
      quote = FALSE,
      file=filename,append=TRUE
    )
  )
  dataset
}

# simData01:
# 2 components, parallel decay, no IRF
source('simData01/simData01.R')


# simData02:
# 2 components, sequential decay, with IRF
source('simData02/simData02.R')

# For test cases 3 and 4 we use more realistic custom axes
# for this we need a more sophisticated function where we can use custom axes for
# time and spectral (wavenumbers / wavelengths)

# Since it's a large function we define it in an external file:
source("simndecay_gen_custom_axes.R")
# and create a wrapper for it:
simulateAndExportDatasetCustomAxes <- function(filename, ...) {
  # dataset <- TIMP::simndecay_gen(...)
  dataset <- simndecay_gen_custom_axes(...)
  cat("filename\n",file=filename)
  cat("dataset name\n",file=filename,append=TRUE)
  cat("Wavelength explicit\n",file=filename,append=TRUE)
  cat("Intervalnr ",  length(dataset@x2),"\n",file=filename,append=TRUE)
  write.table(
    x = dataset@psi.df,
    col.names = dataset@x2,
    row.names = dataset@x,
    sep = " ",
    quote = FALSE,
    file=filename,append=TRUE
  )
  dataset
}

# To make full use of the new function we 
# 1. create a shared time vector
shared_times <- c(head(seq(2, 10, by=0.5),-1),
                  head(seq(10, 50, by=1.5),-1),
                  head(seq(50, 1000, by=15),-1),
                  head(seq(1000, 3100, by=100),-1))

times_no_IRF <- c(
  head(seq(0, 2, by=0.01),-1),
  shared_times
)

times_with_IRF <- c(head(seq(-10, -2, by=0.6),-1),
                    head(seq(-2, 2, by=0.1),-1),
                    shared_times)

print(sprintf("length(times) = %i ", length(times_no_IRF)))
print(sprintf("length(times) = %i ", length(times)))

# 2. create a shared spectra (wavenumber / wavelength) axis

wavenum <- seq(12820, 15120, by=46) # 661.3757 nm to 780.0312 nm per 6nm
spectral <- seq(10**7/15120, 10**7/12820, by=5) # 661.3757 nm to 780.0312 nm
# Formula: 10**7/wavenumber = wavelength
print(sprintf("length(wavenum) = %i ", length(wavenum)))

# 3. Generate the data with the custom axes:

# simData03:
# 2 components, parallel decay, no IRF, custom time and (more narrow) spectral axis
source('simData03/simData03.R')

# simData04:
# 2 components, parallel decay, with IRF, custom time and (more narrow) spectral axis
source('simData04/simData04.R')

