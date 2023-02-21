diagnostics <- function(input) {
  png(filename = "diagnostic.png")
  plot(input$calibration)
  dev.off()
}
