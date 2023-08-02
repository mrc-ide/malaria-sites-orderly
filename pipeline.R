#!/usr/bin/env Rscript
ctry_year <- read.csv("params.csv", strip.white = TRUE)

orderly2::orderly_run("prepare_global_inputs")

for (i in seq_len(nrow(ctry_year))) {
  row <- ctry_year[i,]
  ctry <- row[[1]]
  year <- row[[2]]
  orderly2::orderly_run("fetch_inputs",
                        parameters = list(country = ctry, year = year))
  orderly2::orderly_run("prepare_country_inputs",
                        parameters = list(country = ctry))
  orderly2::orderly_run("process_subnational",
                        parameters = list(country = ctry, year = year))
  orderly2::orderly_run("process_country",
                        parameters = list(country = ctry, year = year))
}

# when running remotely there will be an extra step here to pull dependencies into the orderly root
# on the network share drive

# setup cluster tools
context_root <- "~/net/home/contexts"
ctx <- context::context_save(context_root)

config <- didehpc::didehpc_config(
  workdir = context_root,
  cluster = "mrc"
)
obj <- didehpc::queue_didehpc(ctx, config)

obj$install_packages("vimc/vaultr")
obj$install_packages("mrc-ide/orderly2")
obj$install_packages("dplyr")

regions <- read.csv("sites.csv", strip.white = TRUE)

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
