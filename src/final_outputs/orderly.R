orderly2::orderly_parameters(country = NULL, year = NULL)
orderly2::orderly_dependency(
  "process_country",
  "latest(parameter:country == this:country && parameter:year == this:year)",
  c(stage_3.rds = "stage_3.rds"))
source("R/diagnostics.R")

# Output diagnostics, and preparing to share with others

# Load input
sites <- readRDS("stage_3.rds")
for (region in sites$ID) {
  orderly2::orderly_dependency(
    "calibrate_region",
    "latest(parameter:region == environment:region && parameter:country == this:country && parameter:year == this:year)",
    c("regions/${region}/calibration.rds" = "calibrated.rds"))
}

paths <- file.path("regions", sites$ID, "calibration.rds")
calibration <- do.call("rbind", lapply(paths, readRDS))
sites$calibration <- calibration

# Run some checks
diagnostic_plot <- diagnostics(sites)
orderly2::orderly_artefact("Diagnostic plot", "diagnostic.png")

# Save output for others
saveRDS(sites, "site_file.rds")
orderly2::orderly_artefact("Site file", "site_file.rds")
