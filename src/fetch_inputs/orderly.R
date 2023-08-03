orderly2::orderly_parameters(country = NULL, year = NULL)

# Download a prevalence raster (Global)
r1 <- malariaAtlas::getRaster(surface = "Plasmodium falciparum PR2 - 10 version 2020", year = year)
r2 <- terra::rast(r1)
terra::writeRaster(r2, "prevalence.tif")
orderly2::orderly_artefact("Prevalence raster", "prevalence.tif")

# Download a population raster (by country)
r1 <- cart::get_pop(country, year)
terra::writeRaster(r1, "population.tif")
orderly2::orderly_artefact("Population raster", "population.tif")
