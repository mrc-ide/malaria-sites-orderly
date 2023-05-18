orderly3::orderly_parameters(country = NULL, year = NULL)

deparse(substitute(latest(parameter:country == CTRY && parameter:year == YEAR),
                   list(CTRY = country, YEAR = year)))

orderly3::orderly_dependency("fetch_inputs",
                             deparse(substitute(latest(parameter:country == CTRY && parameter:year == YEAR),
                                                list(CTRY = country, YEAR = year))),
                             c(prevalence.tif = "prevalence.tif", population.tif = "population.tif"))

orderly3::orderly_dependency("prepare_country_inputs",
                             deparse(substitute(latest(parameter:country == CTRY),
                                                list(CTRY = country))),
                             c(spatial.RDS = "spatial.RDS"))
# Get spatial
gadm <- readRDS("spatial.RDS")

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
saveRDS(site_info, "stage_2.RDS")
orderly3::orderly_artefact("Intermediary outputs", "stage_2.RDS")
