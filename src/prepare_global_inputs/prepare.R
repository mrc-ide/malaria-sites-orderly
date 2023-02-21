# Read in csv data and pre process (Global)
burden <- read.csv("data/csv_data.csv")
names(burden) <- c("country", "pfpr")
write.csv(burden, "burden.csv", row.names = FALSE)
