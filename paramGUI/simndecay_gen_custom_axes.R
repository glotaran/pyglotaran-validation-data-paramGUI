#' Simulate data
#'
#' @description Calculates an object of class 'kin'. <TODO>
#'
#' @author Katharine M. Mullen
#' @author Ivo H. M. van Stokkum
#' @author Joris J. Snellenburg
#'
#' @param kinpar vector of rate constants
#' @param tmax last time point
#' @param deltat time step
#' @param specpar vector of spectral parameters for location, width, skewness
#' @param lmin minimum wavelength (nm)
#' @param lmax maximum wavelength (nm)
#' @param deltal wavelength step
#' @param sigma noise level
#' @param irf logical for IRF usage
#' @param irfpar vector of IRF parameters for location, width
#' @param seqmod logical for sequential model
#' @param dispmu logical for dispersion of IRF location mu
#' @param nocolsums logical for <TODO>
#' @param disptau logical for dispersion of IRF width tau
#' @param parmu vector of dispersion parameters for IRF location mu
#' @param partau vector of dispersion parameters for IRF width tau
#' @param lambdac center wavelength for dispersion
#' @param fullk logical for full K matrix
#' @param kmat K matrix
#' @param jvec input vector
#' @param specfun function for spectral shape
#' @param nupow power of nu in spectral model
#' @param irffun function for IRF
#' @param kinscal vector of kinetic scaling parameters
#' @param lightregimespec <TODO>
#' @param specdisp logical for dispersion parameters of spectral parameters
#' @param specdisppar vector of dispersion parameters of spectral parameters
#' @param parmufunc <TODO>
#' @param specdispindex <TODO>
#' @param amplitudes amplitudes of components
#' @param specref <TODO>
#' @param nosiminfo logical for hiding simulation information
#'
#' @return an object of class 'kin'
#' @importFrom TIMP dat kin compModel specparF calcEhiergaus
#' @importFrom stats rnorm
#' @export
#'
"simndecay_gen_custom_axes" <- function(kinpar, times, spectral, specpar = vector(),
                                     sigma, irf = FALSE, irfpar = vector(),
                                     seqmod = FALSE, dispmu = FALSE, nocolsums = FALSE, disptau = FALSE,
                                     parmu = list(), partau = vector(), lambdac = 0, fullk = FALSE,
                                     kmat = matrix(), jvec = vector(), specfun = "gaus", nupow = 1,
                                     irffun = "gaus", kinscal = vector(), lightregimespec = list(),
                                     specdisp = FALSE, specdisppar = list(), parmufunc = "exp",
                                     specdispindex = list(), amplitudes = vector(), specref = 0,
                                     nosiminfo = FALSE) {

  x <- times
  x2 <- spectral
  
  nt <- length(x)
  nl <- length(x2)
  
  ncomp <- length(kinpar)
  
  if (specdisp) {
    ## store all the spectra; could do it otherwise if mem. is an
    ## issue
    EList <- list()
    for (i in 1:nt) {
      sp <- specparF(specpar = specpar, xi = x[i], i = i,
                     specref = specref, specdispindex = specdispindex,
                     specdisppar = specdisppar, parmufunc = parmufunc)
      EList[[i]] <- calcEhiergaus(sp, x2, nupow)
    }
  } else if (nl==1) {
    E2 <- matrix(1, nrow = 1, ncol = ncomp)
    # TODO: set modType to 0?
  } else {
    E2 <- calcEhiergaus(specpar, x2, nupow)
  }
  
  if (!(dispmu || disptau)) {
    if (nt == 1) {
      C2 <- matrix(amplitudes, nrow = 1, ncol = ncomp)
      # TODO: set modType to 0?
    } else {
      C2 <- compModel(k = kinpar, x = x, irfpar = irfpar,
                      irf = irf, seqmod = seqmod, fullk = fullk, kmat = kmat,
                      jvec = jvec, amplitudes = amplitudes, lightregimespec = lightregimespec,
                      nocolsums = nocolsums, kinscal = kinscal)
    }
    if (specdisp) {
      psisim <- matrix(nrow = nt, ncol = nl)
      E2 <- EList[[1]]
      for (i in 1:nt) {
        psisim[i, ] <- t(as.matrix(C2[i, ])) %*% t(EList[[i]])
      }
    } else psisim <- C2 %*% t(E2)
  } else {
    psisim <- matrix(nrow = nt, ncol = nl)
    for (i in 1:nl) {
      irfvec <- irfparF(irfpar, lambdac, x2[i], i, dispmu,
                        parmu, disptau, partau, "", "", "gaus")
      
      C2 <- compModel(k = kinpar, x = x, irfpar = irfpar,
                      irf = irf, seqmod = seqmod, fullk = fullk, kmat = kmat,
                      jvec = jvec, amplitudes = amplitudes, lightregimespec = lightregimespec,
                      nocolsums = nocolsums, kinscal = kinscal)
      psisim[, i] <- C2 %*% cbind(E2[i, ])
    }
  }
  dim(psisim) <- c(nt * nl, 1)
  psi.df <- psisim + sigma * rnorm(nt * nl)
  dim(psi.df) <- c(nt, nl)
  
  if (nosiminfo) {
    dat(psi.df = psi.df, x = x, nt = nt, x2 = x2, nl = nl,
        simdata = FALSE)
  } else {
    kin(psi.df = psi.df, x = x, nt = nt, x2 = x2, nl = nl,
        C2 = C2, E2 = E2, kinpar = kinpar, specpar = specpar,
        seqmod = seqmod, irf = irf, irfpar = irfpar, dispmu = dispmu,
        disptau = disptau, parmu = parmu, partau = partau,
        lambdac = lambdac, simdata = TRUE, fullk = fullk,
        kmat = kmat, jvec = jvec, amplitudes = amplitudes)
  }
}