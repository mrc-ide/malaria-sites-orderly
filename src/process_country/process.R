# Load
subnational_data <- readRDS("inputs/stage_2.RDS")
burden <- read.csv("inputs/burden.csv")

# Rescale
scaler <- get_scaler(subnational_data, burden$pfpr)
rescaled_subnational_data <- subnational_data
rescaled_subnational_data$pfpr <- rescaled_subnational_data$pfpr * scaler

# Save intermediary output
saveRDS(rescaled_subnational_data, "stage_3.RDS")
