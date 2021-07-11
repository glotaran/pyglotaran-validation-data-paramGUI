# The top level script generateTestData.R defines:
# initial_wd <- getwd()
# simulateAndExportDatasetParamGUI
setwd(file.path(initial_wd, "simData02"))
show_plot = FALSE # if TRUE: show on screen, else: write to png
simFilename <- "simData02.ascii"

# global_sigma <- .001
# Experimental parameters
kinpar_sim <- c(0.055, 0.005)
amplitudes_sim <- c(1, 1)
specpar_sim <- list(c(22000, 4000, 0.1), c(20000, 3500, -0.1))
irf_sim <- TRUE
irfpar_sim <- c( 2 , 1 )
seqmod_sim <- TRUE
# Fitting parameters
kinpar_guess <- c(0.05, 0.004)
specpar_guess <- list(c(22000-200, 4000+50, 0.1+0.01), c(20000+100, 3500-50, -0.1-0.01))
irfpar_guess <- c(2.1, 0.9)

# Dataset parameters
tmax_sim = 80
deltat_sim = 1
lmin_sim = 400
lmax_sim = 600
deltal_sim = 5

# Simulate some data!
simulateAndExportDatasetParamGUI(
  simFilename,
  kinpar = kinpar_sim ,
  amplitudes =  amplitudes_sim ,
  tmax =  tmax_sim ,
  deltat =  deltat_sim ,
  specpar =  specpar_sim ,
  lmin =  lmin_sim ,
  lmax =  lmax_sim ,
  deltal =  deltal_sim ,
  sigma =  global_sigma ,
  irf =  irf_sim ,
  irfpar =  irfpar_sim ,
  seqmod = seqmod_sim
)

# Test we can read the data back (it's a valid data file)
test_simData<- readData(simFilename)

## Run a kinetic model
kinModel<- TIMP::initModel(mod_type = "kin",
                             kinpar = kinpar_guess,
                              irf=irf_sim,
                            irfpar=irfpar_guess,
                             seqmod = seqmod_sim
                           )
kinFit<- TIMP::fitModel(
  data = list(test_simData),
  modspec = list(kinModel),
  opt = kinopt(iter = 99,
               plot = FALSE)
)

kinFitSummary<- summary(
  kinFit$currModel@fit@nlsres[[1]],
  currModel = kinFit$currModel,
  currTheta = kinFit$currTheta,
  correlation = TRUE
)

sink("kinFitSummary.txt")
print(kinFitSummary)
sink()

if (!show_plot)
  png('kinFit.png', width = 1024, height = 768, res=100)
plotterforGUI(
  modtype = "kin",
  data = test_simData,
  model = kinModel,
  result = kinFit,
  lin = tmax_sim
)
if (!show_plot)
  dev.off()

## Run a spectral model
specModel<- TIMP::initModel(mod_type = "spec",
                              specpar =  specpar_guess,
                              nupow=1,
                              specfun="gaus")

specFit<- TIMP::fitModel(
  data = list(test_simData),
  modspec = list(specModel),
  opt = specopt(iter = 99,
                plot = FALSE)
)

specFitSummary<- summary(
  specFit$currModel@fit@nlsres[[1]],
  currModel = specFit$currModel,
  currTheta = specFit$currTheta,
  correlation = TRUE
)

sink("specFitSummary.txt")
print(specFitSummary)
sink()

if (!show_plot)
  png('specFit.png', width = 1024, height = 768, res=100)
plotterforGUI(
  modtype = "spec",
  data = test_simData,
  model = specModel,
  result = specFit,
  lin = tmax_sim
)
if (!show_plot)
  dev.off()

# Run a spectral temporal model

specTempModel<- TIMP::initModel(mod_type = "kin",
                             kinpar = kinpar_guess,
                             irf=irf_sim,
                             irfpar=irfpar_guess,
                             seqmod = seqmod_sim)
# here's the crucial bit!
specTempModel@specpar <- specpar_guess

# Spectral-temporal model only supported in paramGUI, not in TIMP
specTempFit<- paramGUI::spectemp(
  sim = test_simData,
  model = specTempModel,
  iter = 99,
  kroncol = FALSE,
  lin = tmax_sim,
  l_posk = FALSE
)

specTempFitSummary<- summary(specTempFit$onls)
sink("specTempFitSummary.txt")
print(specTempFitSummary)
sink()

if (!show_plot)
  png('specTempFit.png', width = 1024, height = 768, res=100)
plotterforGUI(
  modtype = "spectemp",
  data = test_simData,
  model = kinModel,
  result = specTempFit$onls,
  theta = specTempFit$theta,
  lin = tmax_sim
)
if (!show_plot)
  dev.off()

# Reset wd
setwd(file.path(initial_wd))