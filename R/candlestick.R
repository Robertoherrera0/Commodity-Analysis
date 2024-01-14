library(dygraphs)
library(htmlwidgets)
library(xts)
library(dplyr)

current_directory <- getwd()
setwd(current_directory)

print("candle")

crop <- read.csv("R/daily.csv")

crop$date <- as.POSIXct(crop$date, format = "%Y-%m-%d")
start_date <- as.POSIXct("2023-10-02")
filtered_data <- crop %>% 
  filter(date >= start_date) %>%
  arrange(date)

daily_data <- filtered_data %>%
  group_by(date) %>%
  summarize(
    Open = open,
    High = high,
    Low = low,
    Close = close
)

daily_xts <- xts(daily_data[, -1], order.by = daily_data$date)
daily_xts$Mean <- rowMeans(daily_xts[, c("Open", "High", "Low")])


a <- dygraph(daily_xts) %>%
  dyCandlestick()%>%
  dyAxis("x", drawGrid = FALSE) %>%
  dyAxis("y", drawGrid = FALSE) %>%
  dyRangeSelector(height = 23, strokeColor = "")

a <- a %>% dySeries("Mean")
saveWidget(a, file = paste0(getwd(), "/web/plot.html"), selfcontained = FALSE)