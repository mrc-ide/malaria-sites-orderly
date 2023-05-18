orderly3::orderly_parameters(country = NULL, year = NULL)

# Load
orderly3::orderly_dependency("process_subnational",
                             "latest(parameter:country == country && parameter:year == year)",
                             c(stage_2.RDS = "stage_2.RDS", burden.csv = "burden.csv"))
subnational_data <- readRDS("stage_2.RDS")
burden <- read.csv("burden.csv")

# Rescale
scaler <- get_scaler(subnational_data, burden$pfpr)
rescaled_subnational_data <- subnational_data
rescaled_subnational_data$pfpr <- rescaled_subnational_data$pfpr * scaler

# Save intermediary output
saveRDS(rescaled_subnational_data, "stage_3.RDS")
orderly3::orderly_artefact("Intermediary outputs", "stage_3.RDS")
