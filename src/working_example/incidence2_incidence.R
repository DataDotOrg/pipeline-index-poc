# Example of using the incidence2 package to convert linelist data to count data

# get command line args
args <- commandArgs(trailingOnly = TRUE)

# check if the file argument is provided
if (length(args) == 0) {
  stop("No file argument provided. Usage: Rscript incidence2_incidence.R <file>")
}

# read the file path
file_path <- args[1]

aggregate_linelist <- function(file_path) {

    ll_data <- read.csv(file_path)
    aggregated_data <- incidence2::incidence(ll_data, date_index = "date_onset")
    write.csv(aggregated_data, "output.csv", row.names=FALSE)

}

# load the file
if (file.exists(file_path)) {
  aggregate_linelist(file_path)
} else {
  stop("File does not exist.")
}


