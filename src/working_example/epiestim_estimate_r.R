# Example of using the EpiEstim package to estimate the effective reproduction number R parametrically
library(EpiEstim)
library(ggplot2)
library(incidence)

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
#     plot(res_parametric_si, legend = FALSE)
#         Sys.sleep(10) # goes together with quartz/x11/windows
    #     dev.off() # goes together with png(...)
    write.csv(res_parametric_si$R, "output.csv", row.names=FALSE)
}


# load the file
if (file.exists(file_path)) {
  parametric_estimation_of_R(file_path)
} else {
  stop("File does not exist.")
}


