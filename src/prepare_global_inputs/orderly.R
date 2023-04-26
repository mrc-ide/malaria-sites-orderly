# Read in csv data and pre process (Global)
orderly3::orderly_resource("data/csv_data.csv")
burden <- read.csv("data/csv_data.csv")
names(burden) <- c("country", "pfpr")

write.csv(burden, "burden.csv", row.names = FALSE)
orderly3::orderly_artefact("Disease burden csv data", "burden.csv")
