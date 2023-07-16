# 
initial_wd <- getwd()
print(paste('initial workdir (initial_wd): ', initial_wd))

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
  cat("filename\n", file = filename)
  cat("dataset name\n", file = filename, append = TRUE)
  cat("Wavelength explicit\n", file = filename, append = TRUE)
  cat("Intervalnr ",
      length(dataset@x2),
      "\n",
      file = filename,
      append = TRUE)
  suppressWarnings(
    write.table(
      x = dataset@psi.df,
      col.names = dataset@x2,
      row.names = dataset@x,
      sep = " ",
      quote = FALSE,
      file = filename,
      append = TRUE
    )
  )
  dataset
}

simulateAndExportDatasetParamGUI(
  filename = 'tst2023.ascii',
  kinpar = c(0.02, 0.2, 0.05, 0.016, 0.004) , 
  amplitudes =  c(0, 2, 1, 0.8, 0.2) , 
  tmax =  90 , 
  deltat=  0.5 , 
  specpar=  list(c(18000, 2000, 0.01), 
                 c(18000, 2500, 0.01), 
                 c(18000, 2500,  0.01), 
                 c(16000, 2000, -0.01), 
                 c(16000, 2000, -0.01)) , 
                 lmin=  500 , lmax=  700 , deltal=  4 , sigma=  2e-05 , 
                 irf =  FALSE , irfpar = c( 2 , 1 ) , seqmod = TRUE )
