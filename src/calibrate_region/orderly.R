orderly3::orderly_parameters(country = NULL, year = NULL, region = NULL)
orderly3::orderly_artefact("Intermediary outputs", "calibrated.RDS")
orderly3::orderly_dependency("process_country",
                             deparse(substitute(latest(parameter:country == CTRY && parameter:year == YEAR),
                                                list(CTRY = country, YEAR = year))),
                             c(stage_3.RDS = "stage_3.RDS"))

# Load input
input <- readRDS("stage_3.RDS")

# Make params and calibrate
y <- year
input_subnational <- input |> dplyr::filter(ID == region & year == y)
parameters <- make_parameters(input_subnational)
calibration <- calibrate(parameters)

# Save intermediary output
saveRDS(calibration, "calibrated.RDS")
