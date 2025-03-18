setwd("/Users/paulkorir/Documents/Code/Python/epi/myreport")

library(dplyr)
library(ggplot2)
library(forcats)
library(purrr)
library(tidyr)
library(rio)
library(linelist)
library(janitor)
library(kableExtra)
library(grateful)
library(epiparameter)
library(incidence2)

custom_grey <- "#505B5B"
green_grey <- "#5E7E80"
pale_green <- "#B2D1CC"
dark_green <- "#005C5D"
dark_pink <- "#B45D75"

# theme_set(tracetheme::theme_trace())

# To adapt this report to another dataset, change the name of
# the file in the `data_file` parameter at the top of this document.
# Supported file types include .xlsx, .csv, and many others, please visit
# https://gesistsa.github.io/rio/#supported-file-formats for more information.
# The following code is used to rename your input data set as `dat_raw`.
data_path <- params$data_file
# This code imports the input dataset from the data path specified by the user
# (params$data_path)
dat_raw <- data_path %>%
  import() %>%
  tibble() %>%
  # rio (via readxl) tends to use POSIXct for what is encoded as Date in the
  # original data file.
  # But POSIXct is not a good format to work with dates, as discussed in
  # https://github.com/reconverse/incidence2/issues/105
  mutate(across(where(\(x) inherits(x, "POSIXct")), as.Date))
# This is what the data used in this report, `dat_raw`, looks like:
head(dat_raw) %>%
  kbl() %>%
  kable_styling()
# This code identifies key variables for analysis in the input dataset and,
# when working with a linelist, uses the package {linelist} to tag columns in
# the dataset that correspond to these key variables.
date_var <- "date"
group_var <- "region"
# Leave count_var as NULL if your data is really a linelist/patient-level data.
# Update count_var to a character string with the name of the column that
# contains case counts if your data is already aggregated.
count_var <- NULL
# Enter the geographical location where cases in your data took place
country <- "the UK"

dat <- dat_raw %>%
  make_linelist(
    date_admission = date_var,
    location = group_var
  )

min_date <- min(dat_raw[[date_var]])
max_date <- max(dat_raw[[date_var]])

# This code converts daily incidence into weekly incidence using {incidence2}
dat_i <- dat_raw %>%
  incidence("date",
            interval = params$epicurve_unit,
            counts = count_var,
            groups = group_var
  )

# This code creates general variables for automatic customisation of plots
n_groups <- dplyr::n_distinct(get_groups(dat_i)[[1]])
small_counts <- max(get_count_value(dat_i)) < 20
# Plot to visualise an epicurve with total cases of disease over time
dat_i %>%
  plot(fill = group_var, angle = 45, colour_palette = muted) +
  labs(
    title = "Weekly incidence of disease cases", x = "", y = "Incidence")
)
# Plot to generate epicurves stratified by group_var
dat_i %>%
  plot(alpha = 1, nrow = n_groups) +
  labs(x = "", y = "Incidence")
# This code selects relevant variables in the weekly incidence dataset (dat_i),
# group the incidence by variable specified by "group_var", and generate a plot
# that shows the total number of cases, stratified by "group_var".
total_cases <- dat_i %>%
  select(any_of(c(group_var, "count"))) %>%
  group_by(.data[[group_var]]) %>%
  summarise(cases = sum(count)) %>%
  mutate(group_var := fct_reorder(
    .f = .data[[group_var]],
    .x = cases
  ))

ggplot(total_cases, aes(x = cases, y = group_var)) +
  geom_col(fill = green_grey) +
  labs(x = "Total number of cases", y = NULL)


# This code generates a table where total cases are shown, stratified by
# "group_var", as well as the proportion of cases corresponding to each level
# of "group_var".
total_cases %>%
  mutate(
    percentage = sprintf("%.2f%%", cases / sum(cases) * 100)
  ) %>%
  adorn_totals() %>%
  select(-group_var) %>%
  mutate(cases = format(cases, scientific = FALSE, big.mark = " ")) %>%
  set_names(toupper) %>%
  kbl() %>%
  kable_paper("striped", font_size = 18, full_width = FALSE)

# If params$use_epiparameter_database=TRUE, this code accesses the
# {epiparameter} package library of epidemiological parameters to obtain a si
# distribution for params$disease_name, and creates an `epidist` object.
si_epidist <- epidist_db(
  disease =  params$disease_name,
  epi_dist =  "serial_interval",
  single_epidist = TRUE,
  subset = is_parameterised
)

si_params <- get_parameters(si_epidist)
si_dist <- family(si_epidist)
si_mean <- si_params["mean"]

# If params$use_epiparameter_database=FALSE, this code takes the mean and sd for
# the si provided by the user and creates an epidist object
si_mean <- params$si_mean
si_sd <- params$si_sd
si_dist <- params$si_dist
si_epidist <- epidist_db(
  disease = params$disease_name,
  epi_dist = "serial_interval",
  prob_distribution = params$si_dist,
  summary_stats = create_epidist_summary_stats(
  mean = params$si_mean,
  sd = params$si_sd
  ),
  auto_calc_params = TRUE
)
si_epidist <- epiparameter_db(
  disease=params$disease_name,
  epi_dist="serial_interval",
  prob_distribution=params$si_dist,
  summary_stats=create_epidist_summary
