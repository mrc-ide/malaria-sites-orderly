orderly2::orderly_parameters(country = NULL, year = NULL)
orderly2::orderly_dependency("fetch_inputs",
                             "latest(parameter:country == this:country && parameter:year == this:year)",
                             c(prevalence.tif = "prevalence.tif", population.tif = "population.tif"))
orderly2::orderly_dependency("prepare_country_inputs",
                             "latest(parameter:country == this:country)",
                             c(spatial.rds = "spatial.rds"))

source("R/spatial.R")

# Get spatial
gadm <- readRDS("spatial.rds")

# Extract pop raster cell values bu admin
pop_raster <- terra::rast("population.tif")
pop_raw <- long_pixel(pop_raster, pop_raster, gadm, "pop", year)
pop_raw[is.na(pop_raw$pop), "pop"] <- 0

# Extract prevalence raster cell values bu admin
pfpr_rast <- terra::rast("prevalence.tif")
pfpr_raw <- long_pixel(pfpr_rast, pop_raster, gadm, "pfpr", year)

# Some processing for each sub-national unit
site_info <- pop_raw |>
  dplyr::left_join(pfpr_raw, by = c("ID", "pixel", "year")) |>
  dplyr::group_by(ID, year) |>
  dplyr::summarise(pfpr = weighted.mean(pfpr, pop, na.rm = TRUE),
                   pop = sum(pop),
                   .groups = "drop")

# Save intermediary output
saveRDS(site_info, "stage_2.rds")
orderly2::orderly_artefact("Intermediary outputs", "stage_2.rds")
