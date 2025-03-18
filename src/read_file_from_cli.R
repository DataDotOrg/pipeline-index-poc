# get command line args
args <- commandArgs(trailingOnly = TRUE)

# print args
print(args)

# check if the file argument is provided
if (length(args) == 0) {
  stop("No file argument provided. Usage: Rscript read_file_from_cli.R <file>")
}

# read the file path
file_path <- args[1]

# load the file
if (file.exists(file_path)) {
  data <- read.csv(file_path)
  print(data)
} else {
  stop("File does not exist.")
}
