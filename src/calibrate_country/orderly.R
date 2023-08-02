orderly2::orderly_parameters(country = NULL, year = NULL)
orderly2::orderly_artefact("Intermediary outputs", "stage_4.rds")
orderly2::orderly_dependency(
  "process_country",
  "latest(parameter:country == this:country && parameter:year == this:year)",
  c(stage_3.rds = "stage_3.rds"))
source("R/calibrate.R")

# Load input
input <- readRDS("stage_3.rds")

calibration <- c()
for (i in seq_len(nrow(input))) {
  parameters <- make_parameters(input[i,])
  # The following would be submitted to the cluster, or this whole
  # task might be run on the cluster?
  calibration[i] <- calibrate(parameters)
}

# Collate cluster output and append to site information
calbrated_site <- input
calbrated_site$calibration <- calibration

# Save intermediary output
saveRDS(calbrated_site, "stage_4.rds")
