## If not initialised after a clone, you need to run:
orderly2::orderly_init(".")

ctry_year <- read.csv("params.csv", strip.white = TRUE)
regions <- read.csv("sites.csv", strip.white = TRUE)

orderly2::orderly_run("prepare_global_inputs")

for (i in seq_len(nrow(ctry_year))) {
  ctry <- ctry_year$country[[i]]
  year <- ctry_year$year[[i]]
  orderly2::orderly_run("fetch_inputs",
                        parameters = list(country = ctry, year = year))
  orderly2::orderly_run("prepare_country_inputs",
                        parameters = list(country = ctry))
  orderly2::orderly_run("process_subnational",
                        parameters = list(country = ctry, year = year))
  orderly2::orderly_run("process_country",
                        parameters = list(country = ctry, year = year))
}

# you will probably want to work on the calibrate_region steps locally
# before attempting to submit to the cluster:
orderly2::orderly_run("calibrate_region",
                      parameters = list(country = regions$country[[1]],
                                        region = regions$region[[1]],
                                        year = regions$year[[1]]))

# when running remotely there will be an extra step here to pull dependencies into the orderly root
# on the network share drive
# setup cluster tools
ctx <- context::context_save("contexts")

config <- didehpc::didehpc_config(cluster = "big")
obj <- didehpc::queue_didehpc(ctx, config = config)
obj$install_packages("mrc-ide/orderly2")
obj$install_packages("dplyr")

# queue all calibrations
bundle <- obj$enqueue_bulk(regions, function(country, region, year) {
  orderly2::orderly_run("calibrate_region",
                        parameters = list(country = country,
                                          region = region,
                                          year = year))
})

# extract dependencies

deps <- lapply(seq_len(nrow(ctry_year)), function(i) {
  bundle$ids[bundle$X$country == ctry_year$country[[i]] & bundle$X$year == ctry_year$year[[i]]]
})

# queue aggregation steps with dependencies
aggregation_bundle <- obj$enqueue_bulk(ctry_year, function(country, year) {
  orderly2::orderly_run("final_outputs",
                        parameters = list(country = country,
                                          year = year))
}, depends_on = deps)

# final step would be to push the results to the orderly remote


# The last steps could also be run without the cluster:
for (i in seq_len(nrow(regions))) {
  orderly2::orderly_run("calibrate_region",
                        parameters = as.list(regions[i, ]))
}

for (i in seq_len(nrow(ctry_year))) {
  orderly2::orderly_run("final_outputs", parameters = as.list(ctry_year[i, ]))
}
