library(dygraphs)
library(xts)
library(htmlwidgets)

# Read the CSV file
crop <- read.csv("data.csv")

crop$Date <- as.POSIXct(crop$Datetime, format = "%Y-%m-%d %H:%M:%S")
#--------------------------------------------------------------------
# Time series scatter

crop_xts <- xts(x = crop$Highest.Price, order.by = crop$Date)

p <- dygraph(crop_xts, main = "Time series for Gold Prices") %>%
  dySeries("V1", label = "Price", color = "darkblue") %>%
  dyOptions(stackedGraph = TRUE, fillAlpha = .2) %>%
  dyAxis("y", label = "Price", drawGrid = FALSE) %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dyRangeSelector(strokeColor = "gray")


saveWidget(p, file = paste0(getwd(), "/web/plot.html"), selfcontained = FALSE)