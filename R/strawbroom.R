current_directory <- getwd()
setwd(current_directory)
crop <- read.csv("R/daily.csv")

library(dygraphs)
library(htmlwidgets)
library(xts)
library(dplyr)


crop$date <- as.Date(crop$date, format = "%Y-%m-%d")

library(quantmod)
library(dygraphs)

start_date <- as.Date("2023-10-16")

# Filter and arrange your data
filtered_data <- crop %>%
  filter(date >= start_date) %>%
  arrange(date)

# Create xts objects for VWAP and moving average
vwap_xts <- xts(filtered_data$vwap, order.by = filtered_data$date)

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
# Calculate the moving average (you can adjust the window)


# Merge the two xts objects
price_data_xts <- merge(vwap_xts, daily_xts$Mean)

# Name the columns appropriately
colnames(price_data_xts) <- c("VWAP", "SMA")

# Create the dygraph and add a range selector
b <- dygraph(price_data_xts) %>%
  dyAxis("y", drawGrid = FALSE) %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dyRangeSelector(height = 23, strokeColor = "")

saveWidget(b, file = paste0(getwd(), "/web/straw.html"), selfcontained = FALSE)