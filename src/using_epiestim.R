# There are three analyses here:
#   1. Estimate R when the serial interval is parametrically defined
#   2. Estimate R when the serial interval distribution is non-parametrically defined.
#   3. Estimate R when the serial interval data is provided.
#  We are only interested in 1 and 2 for the data interop case.

library(EpiEstim)
library(ggplot2)
library(incidence)

# data(Flu2009)
# head(Flu2009$si_distr)
# sum(Flu2009$si_distr)

# get command line args
args <- commandArgs(trailingOnly = TRUE)

# print args
# print(args)

# check if the file argument is provided
if (length(args) == 0) {
  stop("No file argument provided. Usage: Rscript using_epiestim.R <file>")
}

# read the file path
file_path <- args[1]

# function to do the analysis
parametric_estimation_of_R <- function(file_path) {
    # notify the user
    print(cat("Carrying out analysis using file '", file_path, "'..."))
    data <- read.csv(file_path, colClasses=c("Date", "numeric"))
    res_parametric_si <- estimate_R(
      data,
      method="parametric_si",
      config = make_config(list(
      mean_si = 2.6,
      std_si = 1.5))
    )
    #     png("output_plot.png")
        quartz() # macOS
    # x11() # linux
    # windows() # windows
    plot(res_parametric_si, legend = FALSE)
        Sys.sleep(10) # goes together with quartz/x11/windows
    #     dev.off() # goes together with png(...)
}


# load the file
if (file.exists(file_path)) {
  parametric_estimation_of_R(file_path)
} else {
  stop("File does not exist.")
}

stop("End of script.")


head(Flu2009_incidence)

# Flu2009$si_distr
head(Flu2009_si_data)

# 1. parametric estimation of R
print("Parametric estimation of R:")
res_parametric_si <- estimate_R(
  Flu2009_incidence, 
  method="parametric_si",
  config = make_config(list(
  mean_si = 2.6, 
  std_si = 1.5))
)

plot(res_parametric_si, legend = FALSE)

# 3. non-parametric estimation of R from the serial interval data
print("Non-parametric estimation of R:")
Flu2009_si_data <- read.csv("data/Flu2009_si_data.csv")
MCMC_seed <- 1
overall_seed <- 2
mcmc_control <- make_mcmc_control(seed = MCMC_seed, 
                                  burnin = 1000)
dist <- "G" # fitting a Gamma dsitribution for the SI
config <- make_config(list(si_parametric_distr = dist,
                           mcmc_control = mcmc_control,
                           seed = overall_seed, 
                           n1 = 50, 
                           n2 = 50))
res_si_from_data <- estimate_R(Flu2009$incidence,
                               method = "si_from_data",
                               si_data = Flu2009_si_data,
                               config = config)
plot(res_si_from_data, legend=FALSE)


