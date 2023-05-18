#!/usr/bin/env Rscript

root <- "~/net/home/contexts"
orderly_root <- "~/net/home/malaria-sites-orderly"
ctry_year <- read.csv("params.csv", strip.white = TRUE)

# run first part of pipeline, here locally but ultimately this would be run remotely
for (i in 1:nrow(ctry_year)) {
  row <- ctry_year[i,]
  year <- row[[1]]
  ctry <- row[[2]]
  orderly3::orderly_run("fetch_inputs",
                        parameters = list(country = ctry, year = year),
                        root = orderly_root)
  orderly3::orderly_run("prepare_country_inputs",
                        parameters = list(country = ctry),
                        root = orderly_root)
  orderly3::orderly_run("process_subnational",
                        parameters = list(country = ctry, year = year),
                        root = orderly_root)
  orderly3::orderly_run("process_country",
                        parameters = list(country = ctry, year = year),
                        root = orderly_root)
}

# when running remotely there will be an extra step here to pull dependencies into the orderly root
# on the network share drive

# setup cluster tools
ctx <- context::context_save(root)

config <- didehpc::didehpc_config(
  workdir = root,
  cluster = "mrc"
)
obj <- didehpc::queue_didehpc(ctx, config)

obj$install_packages("vimc/vaultr")
obj$install_packages("mrc-ide/orderly3")
obj$install_packages("dplyr")

regions <- read.csv("sites.csv", strip.white = TRUE)

# queue all calibrations
bundle <- obj$enqueue_bulk(regions, function(country, region, year) orderly3::orderly_run("calibrate_region",
                                                                                          parameters = list(country = country,
                                                                                                            region = region,
                                                                                                            year = year),
                                                                                          root = orderly_root))

# extract dependencies
deps <- apply(ctry_year, 1, function(row) bundle$ids[bundle$X$country == row[2] && bundle$X$year == row[1]])

# queue aggregation steps with dependencies
aggregation_bundle <- obj$enqueue_bulk(ctry_year, function(country, year) orderly3::orderly_run("final_outputs",
                                                                                                parameters = list(country = country,
                                                                                                                  year = year),
                                                                                                use_draft = TRUE),
                                       depends_on = deps)

# final step would be to push the results to the orderly remote