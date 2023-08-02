#!/usr/bin/env Rscript
ctry_year <- read.csv("params.csv", strip.white = TRUE)

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
regions <- read.csv("sites.csv", strip.white = TRUE)

orderly2::orderly_run("calibrate_region",
                      parameters = list(country = regions$country[[1]],
                                        region = regions$region[[1]],
                                        year = regions$year[[1]]))

# when running remotely there will be an extra step here to pull dependencies into the orderly root
# on the network share drive
# setup cluster tools
context_root <- "contexts"
ctx <- context::context_save(context_root)

config <- didehpc::didehpc_config(cluster = "big")
obj <- didehpc::queue_didehpc(ctx, config = config)
obj$install_packages("mrc-ide/orderly2")
obj$install_packages("dplyr")



# queue all calibrations
bundle <- obj$enqueue_bulk(regions, function(country, region, year) {
  orderly2::orderly_run("calibrate_region",
                        parameters = list(country = country,
                                          region = region,
                                          year = year),
                        root = orderly_root)
})

# extract dependencies
deps <- apply(ctry_year, 1, function(row) bundle$ids[bundle$X$country == row[[1]] && bundle$X$year == row[[2]]])

# queue aggregation steps with dependencies
aggregation_bundle <- obj$enqueue_bulk(ctry_year, function(country, year) {
  orderly3::orderly_run("final_outputs",
                        parameters = list(country = country,
                                          year = year),
                        use_draft = TRUE)
}, depends_on = deps)

# final step would be to push the results to the orderly remote
