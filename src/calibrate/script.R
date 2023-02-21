# Load input
input <- readRDS("inputs/stage_3.RDS")

calibration <- c()
for(i in seq_len(nrow(input))){
  parameters <- make_parameters(input[i,])
  # The foillowing would be submitted to the cluster:
  calibration[i] <- calibrate(parameters)
}

# Collate cluster output and append to site information
calbrated_site <- input
calbrated_site$calibration <- calibration

# Save intermediary output
saveRDS(calbrated_site, "stage_4.RDS")
