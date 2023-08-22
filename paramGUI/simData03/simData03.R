# The top level script generateTestData.R defines:
# initial_wd <- getwd()
# simulateAndExportDatasetParamGUI
setwd(file.path(initial_wd, "simData03"))
show_plot = FALSE # if TRUE: show on screen, else: write to png
simFilename <- "simData03.ascii"

# global_sigma <- .001
# Experimental parameters
kinpar_sim <- c(0.025, 0.001)
amplitudes_sim <- c(1, 1)
specpar_sim <- list(c(14285, 800, 0.4), c(13700, 650, -0.3))
irf_sim <- FALSE
irfpar_sim <- vector()
seqmod_sim <- FALSE
# Fitting parameters
kinpar_guess <- c(0.02, 0.002)
specpar_guess <- list(c(14285-50, 800+50, 0.4-0.1), c(13700+200, 650-50, -0.3+0.1))

# Simulate some data!
simulateAndExportDatasetCustomAxes(simFilename,
                                   kinpar = kinpar_sim ,
                                   amplitudes =  c(1, 1) ,
                                   times = times_no_IRF,
                                   specpar=  specpar_sim ,
                                   spectral = spectral,
                                   sigma=  global_sigma ,
                                   irf =  irf_sim ,
                                   irfpar = irfpar_sim ,
                                   seqmod = seqmod_sim )


# Test we can read the data back (it's a valid data file)
test_simData<- readData(simFilename)

## Run a kinetic model
kinModel<- TIMP::initModel(mod_type = "kin",
                             kinpar = kinpar_guess,
                             seqmod = seqmod_sim)
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
                             irfpar = irfpar_sim,
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
