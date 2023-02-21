get_scaler <- function(subnational_data, country_pfpr){
  subnational_data <- weighted.mean(subnational_data$pfpr, subnational_data$pop)
  country_pfpr / subnational_data
}
