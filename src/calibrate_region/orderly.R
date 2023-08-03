orderly2::orderly_parameters(country = NULL, year = NULL, region = NULL)
orderly2::orderly_artefact("Intermediary outputs", "calibrated.rds")
orderly2::orderly_dependency(
  "process_country",
  "latest(parameter:country == this:country && parameter:year == this:year)",
  c(stage_3.rds = "stage_3.rds"))
source("R/calibrate.R")

# Load input
input <- readRDS("stage_3.rds")

# Make params and calibrate
y <- year
input_subnational <- input |> dplyr::filter(ID == region & year == y)
parameters <- make_parameters(input_subnational)
calibration <- calibrate(parameters)

# Save intermediary output
saveRDS(calibration, "calibrated.rds")
