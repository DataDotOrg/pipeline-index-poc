library(EpiNow2)

# estimate reporting delay
reporting_delay <- estimate_delay(
  rlnorm(1000, log(2), 1),
  
)
example_generation_time
example_incubation_period
reported_cases <- example_confirmed[1:60]
head(reported_cases)
summary(reported_cases)
dim(reported_cases)

write.csv(reported_cases, "epinow2_reported_cases.csv", row.names = FALSE)

estimates <- epinow(
  data = reported_cases,
  generation_time = gt_opts(example_generation_time),
  delays = delay_opts(example_incubation_period + reporting_delay),
  rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
  stan = stan_opts(cores = 4),
  verbose = interactive()
)
