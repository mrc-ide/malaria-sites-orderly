source("R/diagnostics.R")
orderly3::orderly_parameters(country = NULL, year = NULL)
orderly3::orderly_dependency("process_country",
                             "latest(parameter:country == this:country && parameter:year == this:year)",
                             c(stage_3.RDS = "stage_3.RDS"))

# Output diagnostics, and preparing to share with others

# Load input
sites <- readRDS("stage_3.RDS")
lapply(sites$ID, function(region) orderly3::orderly_dependency("calibrate_region",
                                                               "latest(parameter:region == this:region && parameter:country == this:country && parameter:year == this:year)",
                                                               c("regions/region/calibration.RDS" = "calibrated.RDS")))

paths <- file.path("regions", ids, "calibrated.RDS")
calibration <- do.call("rbind", lapply(paths, readRDS))
sites$calibration <- calibration

# Run some checks
diagnostic_plot <- diagnostics(sites)
orderly3::orderly_artefact("Diagnostic plot", "diagnostic.png")

# Save output for others
saveRDS(sites, "site_file.RDS")
orderly3::orderly_artefact("Site file", "site_file.RDS")
