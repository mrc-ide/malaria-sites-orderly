# Download a prevalence raster (Global)
r1 <- malariaAtlas::getRaster(surface = "Plasmodium falciparum PR2 - 10 version 2020", year = year)
r2 <- terra::rast(r1)
terra::writeRaster(r2, "prevalence.tif")

# Download a population raster (by country)
r1 <- cart::get_pop(country, year)
raster_name <- paste0("population.tif")
terra::writeRaster(r1, raster_name)
