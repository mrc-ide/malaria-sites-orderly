# Output diagnostics, and preparing to share with others

# Load input
input <- readRDS("inputs/stage_4.RDS")

# Run some checks
diagnostic_plot <- diagnostics(input)

# Save output for others
saveRDS(input, "site_file.RDS")
