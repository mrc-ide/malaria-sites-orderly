#!/usr/bin/env Rscript

countries <- c("NGA")
years <- 2018:2018

get_cluster_obj <- function() {
  root <- "~/net/home/contexts"
  ctx <- context::context_save(root, packages = c("orderly", "dplyr"))

  config <- didehpc::didehpc_config(
    workdir = root,
    cluster = "mrc"
  )
  didehpc::queue_didehpc(ctx, config)
}

country_pipeline <- function(ctry, year, use_cluster = FALSE) {
  orderly::orderly_commit(orderly::orderly_run("fetch_inputs",
                                               parameters = list(country = ctry, year = year)))
  orderly::orderly_commit(orderly::orderly_run("prepare_country_inputs",
                                               parameters = list(country = ctry)))
  orderly::orderly_commit(orderly::orderly_run("process_subnational",
                                               parameters = list(country = ctry, year = year)))
  orderly::orderly_commit(orderly::orderly_run("process_country",
                                               parameters = list(country = ctry, year = year)))

  id <- orderly::orderly_search(paste0("latest(parameter:country == \"", ctry,
                                       "\" && parameter:year == ", year,
                                       ")"),
                                "process_country")
  sites <- readRDS(file.path("archive/process_country", id, "stage_3.RDS"))

  orderly_root <- here::here()
  if (use_cluster) {
    root <- "~/net/home/contexts"
  } else {
    root <- orderly_root
  }
  path_bundles <- file.path(root, "bundles")
  output_path <- "output"
  bundle_paths <- lapply(sites$ID, function(x) orderly::orderly_bundle_pack(path_bundles, "calibrate_region",
                                                                            parameters = list(country = ctry, region = x, year = year),
                                                                            root = orderly_root)$path)

  if (use_cluster) {
    obj <- get_cluster_obj()
    relative_bundle_paths <- lapply(bundle_paths, function(x) {
      paste(dplyr::last(strsplit(dirname(x), "/")[[1]]),
            basename(x), sep = "/")
    })
    t <- obj$lapply(relative_bundle_paths, orderly::orderly_bundle_run, workdir = output_path)
    tasks <- t$tasks

    for (output in t$wait(100)) {
      out <- strsplit(output$path, "\\\\")[[1]]
      output_filename <- out[length(out)]
      orderly::orderly_bundle_import(file.path(root, output_path, output_filename),
                                     root = orderly_root)
    }
  } else {
    res <- lapply(bundle_paths, orderly::orderly_bundle_run, workdir = output_path)
    lapply(res, function(x) orderly::orderly_bundle_import(x$path, root = orderly_root))
  }

  orderly::orderly_commit(orderly::orderly_run("final_outputs",
                                               parameters = list(country = ctry, year = year)))
}

orderly::orderly_commit(orderly::orderly_run("prepare_global_inputs"))
for (i in seq_along(countries)) {
  for (year in years) {
    country_pipeline(countries[i], year)
  }
}
