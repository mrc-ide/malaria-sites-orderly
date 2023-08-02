orderly2::orderly_parameters(country = NULL, year = NULL)
orderly2::orderly_dependency("process_subnational",
                             "latest(parameter:country == this:country && parameter:year == this:year)",
                             c(stage_2.rds = "stage_2.rds"))
orderly2::orderly_dependency("prepare_global_inputs",
                             "latest()",
                             c(burden.csv = "burden.csv"))
source("R/rescale.R")

subnational_data <- readRDS("stage_2.rds")
burden <- read.csv("burden.csv")

# Rescale
scaler <- get_scaler(subnational_data, burden$pfpr)
rescaled_subnational_data <- subnational_data
rescaled_subnational_data$pfpr <- rescaled_subnational_data$pfpr * scaler

# Save intermediary output
saveRDS(rescaled_subnational_data, "stage_3.rds")
orderly2::orderly_artefact("Intermediary outputs", "stage_3.rds")
