countries <- c("NGA")
years <- 2018:2018

country_pipeline <- function(ctry, year) {
  orderly::orderly_run("fetch_inputs",
                       parameters=list(country=ctry, year=year),
                       use_draft=TRUE)
  orderly::orderly_run("prepare_country_inputs",
                       parameters=list(country=ctry),
                       use_draft=TRUE)
  orderly::orderly_run("process_subnational",
                       parameters=list(country=ctry, year=year),
                       use_draft=TRUE)
  orderly::orderly_run("process_country",
                       parameters=list(country=ctry, year=year),
                       use_draft=TRUE)
  orderly::orderly_run("calibrate",
                       parameters=list(country=ctry, year=year),
                       use_draft=TRUE)
  orderly::orderly_run("final_outputs",
                       parameters=list(country=ctry, year=year),
                       use_draft=TRUE)
}

orderly::orderly_run("prepare_global_inputs")
for (i in seq_along(countries)) {
  for (year in years) {
    country_pipeline(countries[i], year)
  }
}
