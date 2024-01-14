# ARIMA-GARCH
library(forecast)
library(rugarch)
library(htmlwidgets)
library(TTR)
library(dplyr)
library(ggplot2)
library(plotly)


setwd(getwd())
crop <- read.csv("R/daily.csv")

crop$date <- as.POSIXct(crop$date, format = "%Y-%m-%d")
frequency <- 365
crop <- crop %>%
  arrange(date)


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# LOWEST PRICE

pricelow <- ts(crop$low, frequency = frequency)

auto_arima_modellow <- auto.arima(pricelow, d = 1)
forecast_futurelow <- forecast(auto_arima_modellow, h = 1)

residuals_low <- residuals(auto_arima_modellow)

# Specify GARCH model
spec_garch <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                         mean.model = list(armaOrder = c(0,0), include.mean = FALSE))

# Fit GARCH model
garch_fit_low <- ugarchfit(spec = spec_garch, data = residuals_low)

# Forecasting volatility
garch_forecast_low <- ugarchforecast(garch_fit_low, n.ahead = 1)
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# OPENING PRICE
priceop <- ts(crop$open, frequency = frequency)

auto_arima_modelop <- auto.arima(priceop, d = 1)
forecast_futureop <- forecast(auto_arima_modelop, h = 1)
residuals_op <- residuals(auto_arima_modelop)

# Specifying GARCH model
spec_garch_op <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                            mean.model = list(armaOrder = c(0,0), include.mean = FALSE))

# Fitting GARCH model
garch_fit_op <- ugarchfit(spec = spec_garch_op, data = residuals_op)

# Forecasting volatility
garch_forecast_op <- ugarchforecast(garch_fit_op, n.ahead = 1)
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# HIGHEST PRICE
pricehi <- ts(crop$high, frequency = frequency)

auto_arima_modelhi <- auto.arima(pricehi, d = 1)
forecast_futurehi <- forecast(auto_arima_modelhi, h = 1)
residuals_hi <- residuals(auto_arima_modelhi)

# Specifying GARCH model
spec_garch_hi <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                            mean.model = list(armaOrder = c(0,0), include.mean = FALSE))

# Fitting GARCH model
garch_fit_hi <- ugarchfit(spec = spec_garch_hi, data = residuals_hi)

# Forecasting volatility
garch_forecast_hi <- ugarchforecast(garch_fit_hi, n.ahead = 1)
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# CLOSING PRICE

priceclo <- ts(crop$close, frequency = frequency)

auto_arima_modelclo <- auto.arima(priceclo, d = 1)
forecast_futureclo <- forecast(auto_arima_modelclo, h = 1)

residuals_clo <- residuals(auto_arima_modelclo)

# Specifying GARCH model
spec_garch_clo <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                             mean.model = list(armaOrder = c(0,0), include.mean = FALSE))

# Fitting GARCH model
garch_fit_clo <- ugarchfit(spec = spec_garch_clo, data = residuals_clo)

# Forecasting volatility
garch_forecast_clo <- ugarchforecast(garch_fit_clo, n.ahead = 1)

#------------------------------------------------------------------------------------------------

forecast_op <- forecast_futureop$mean
forecast_low <- forecast_futurelow$mean
forecast_hi <- forecast_futurehi$mean
forecast_clo <- forecast_futureclo$mean
volatility_op <- sigma(garch_forecast_op)
volatility_low <- sigma(garch_forecast_low)
volatility_hi <- sigma(garch_forecast_hi)
volatility_clo <- sigma(garch_forecast_clo)


#-----------------------------------------------------------------------------


library(ggplot2)
library(plotly)


crop$date <- as.Date(crop$date)
start_date <- as.Date("2023-10-02")


crop <- crop %>%
  filter(date >= start_date)

# Extend the date range for forecasted data
forecast_date <- max(crop$date) + 1

# Create a data frame for plotting
plot_data <- rbind(
  data.frame(Date = crop$date, Price = crop$close, Type = "Close", Source = "Historical"),
  data.frame(Date = crop$date, Price = crop$low, Type = "Low", Source = "Historical"),
  data.frame(Date = crop$date, Price = crop$high, Type = "High", Source = "Historical"),
  data.frame(Date = crop$date, Price = crop$open, Type = "Open", Source = "Historical"),
  data.frame(Date = forecast_date, Price = forecast_clo, Type = "Close", Source = "Forecasted"),
  data.frame(Date = forecast_date, Price = forecast_low, Type = "Low", Source = "Forecasted"),
  data.frame(Date = forecast_date, Price = forecast_hi, Type = "High", Source = "Forecasted"),
  data.frame(Date = forecast_date, Price = forecast_op, Type = "Open", Source = "Forecasted")
)



window_size <- 20

# Calculate Bollinger Bands
calc_bollinger_bands <- function(price_data, dates) {
  bbands_data <- BBands(price_data, n = window_size)
  data.frame(Date = dates, BB_Upper = bbands_data[, "up"], BB_Lower = bbands_data[, "dn"])
}

# Make sure the 'date' column in 'crop' is of Date type
crop$date <- as.Date(crop$date)

# Calculate Bollinger Bands for each price type
bb_open <- calc_bollinger_bands(crop$open, crop$date)
bb_close <- calc_bollinger_bands(crop$close, crop$date)
bb_high <- calc_bollinger_bands(crop$high, crop$date)
bb_low <- calc_bollinger_bands(crop$low, crop$date)
names(bb_open)[2:3] <- c("BB_Upper_open", "BB_Lower_open")
names(bb_close)[2:3] <- c("BB_Upper_close", "BB_Lower_close")
names(bb_high)[2:3] <- c("BB_Upper_high", "BB_Lower_high")
names(bb_low)[2:3] <- c("BB_Upper_low", "BB_Lower_low")


# Merge Bollinger Bands with plot_data
plot_data <- plot_data %>%
  left_join(bb_open, by = "Date") %>%
  left_join(bb_close, by = "Date", suffix = c("_open", "_close")) %>%
  left_join(bb_high, by = "Date", suffix = c("", "_high")) %>%
  left_join(bb_low, by = "Date", suffix = c("", "_low"))


p <- ggplot(plot_data, aes(x = Date, y = Price)) +
  geom_line(data = plot_data[plot_data$Source == "Historical", ], aes(color = "Historical")) +
  geom_ribbon(data = plot_data[plot_data$Type == "Open" & plot_data$Source == "Historical", ], aes(ymin = BB_Lower_open, ymax = BB_Upper_open), fill = "dodgerblue3", alpha = 0.2) +
  geom_ribbon(data = plot_data[plot_data$Type == "Close" & plot_data$Source == "Historical", ], aes(ymin = BB_Lower_close, ymax = BB_Upper_close), fill = "firebrick", alpha = 0.2) +
  geom_ribbon(data = plot_data[plot_data$Type == "High" & plot_data$Source == "Historical", ], aes(ymin = BB_Lower_high, ymax = BB_Upper_high), fill = "chartreuse2", alpha = 0.2) +
  geom_ribbon(data = plot_data[plot_data$Type == "Low" & plot_data$Source == "Historical", ], aes(ymin = BB_Lower_low, ymax = BB_Upper_low), fill = "gold", alpha = 0.2) +
  geom_point(data = plot_data[plot_data$Source == "Forecasted", ], aes(color = "Forecast"), size = 2, shape = 16) +
  facet_wrap(~Type, scales = "free_y") +
  theme_minimal() +
  labs( 
       x = "Date", 
       y = "Price") +
  scale_color_manual("", values = c("Historical" = "black", "Forecast" = "blue"))

gg <- ggplotly(p, tooltip = c("x", "y", "ymin", "ymax"))

saveWidget(gg, file = paste0(getwd(), "/web/arima.html"), selfcontained = FALSE)
