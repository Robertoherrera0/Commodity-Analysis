current_directory <- getwd()
setwd(current_directory)
crop <- read.csv("R/daily.csv")

library(dygraphs)
library(htmlwidgets)
library(dplyr)

crop$date <- as.POSIXct(crop$date, format = "%Y-%m-%d")
start_date <- as.POSIXct("2023-10-02")

# Filter out rows with 'volume' equal to 0
filtered_data <- crop %>%
  filter(date >= start_date, volume != 0) %>%
  select(date, volume) %>%
  arrange(date)

c <- dygraph(filtered_data) %>%
  dyBarChart() %>%
  dyAxis("y", label = "Volume", drawGrid = FALSE) %>%
  dyAxis("x", label = "Date", drawGrid = FALSE) %>%
  dyRangeSelector(height = 23, strokeColor = '') %>%
  dySeries("volume", label = "Volume") %>%
  dyOptions(drawGapEdgePoints = TRUE)

saveWidget(c, file = paste0(getwd(), "/web/barchart.html"), selfcontained = FALSE)
