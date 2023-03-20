# Output diagnostics, and preparing to share with others

# Load input
sites <- readRDS("inputs/stage_3.RDS")
root <- orderly::orderly_config()$root
ids <- lapply(sites$ID, function(x) orderly::orderly_search(paste0("latest(parameter:region == \"", x,
                                                "\" && parameter:year == ", year,
                                                ")"),
                                         "calibrate_region", root = root))

paths <- file.path(root, "archive/calibrate_region", ids, "calibrated.RDS")
calibration <- do.call("rbind", lapply(paths, readRDS))
sites$calibration <- calibration

# Run some checks
diagnostic_plot <- diagnostics(sites)

# Save output for others
saveRDS(sites, "site_file.RDS")
