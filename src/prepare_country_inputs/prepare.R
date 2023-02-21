# Get a spatial file
spatial_raw <- readr::read_file(paste0("data/gadm41_", country, "_1.json"))
spatial <- geojsonsf::geojson_sf(spatial_raw)
saveRDS(spatial, "spatial.RDS")
