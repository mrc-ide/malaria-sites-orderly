# Load input
input <- readRDS("inputs/stage_3.RDS")

# Make params and calibrate
y <- year
input_subnational <- input |> dplyr::filter(ID == region & year == y)
parameters <- make_parameters(input_subnational)
calibration <- calibrate(parameters)

# Save intermediary output
saveRDS(calibration, "calibrated.RDS")
