orderly3::orderly_parameters(country = NULL)

# Get a spatial file
gad_file <- paste0("data/gadm41_", country, "_1.json")
orderly3::orderly_resource(gad_file)
spatial_raw <- readr::read_file(gad_file)
spatial <- geojsonsf::geojson_sf(spatial_raw)
saveRDS(spatial, "spatial.RDS")
orderly3::orderly_artefact("Spatial file for country", "spatial.RDS")
