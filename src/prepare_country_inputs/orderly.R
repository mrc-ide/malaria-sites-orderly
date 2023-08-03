orderly2::orderly_parameters(country = NULL)
orderly2::orderly_strict_mode()

# Get a spatial file
gad_file <- paste0("data/gadm41_", country, "_1.json")
orderly2::orderly_resource(gad_file)

spatial_raw <- readr::read_file(gad_file)
spatial <- geojsonsf::geojson_sf(spatial_raw)

orderly2::orderly_artefact("Spatial file for country", "spatial.rds")
saveRDS(spatial, "spatial.rds")
