orderly3::orderly_parameters(country = NULL, year = NULL)
orderly3::orderly_artefact("Intermediary outputs", "stage_4.RDS")
orderly3::orderly_dependency("process_country",
                             deparse(substitute(latest(parameter:country == CTRY && parameter:year == YEAR),
                                                list(CTRY = country, YEAR = year))),
                             c(stage_3.RDS = "stage_3.RDS"))

# Load input
input <- readRDS("stage_3.RDS")

calibration <- c()
for (i in seq_len(nrow(input))) {
  parameters <- make_parameters(input[i,])
  # The foillowing would be submitted to the cluster:
  calibration[i] <- calibrate(parameters)
}

# Collate cluster output and append to site information
calbrated_site <- input
calbrated_site$calibration <- calibration

# Save intermediary output
saveRDS(calbrated_site, "stage_4.RDS")
