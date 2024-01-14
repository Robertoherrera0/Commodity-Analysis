# Commodity Data Analysis

## Overview

The Commodity Data Analysis project is a Python-based tool for retrieving, formatting, and exporting historical commodity data for analysis. This tool utilizes Yahoo Finance's API to fetch historical data with 1-minute granularity for a specified commodity ETF (Exchange-Traded Fund). The retrieved data is then formatted and saved to a CSV file, which can be used for further analysis, including data visualization, statistical analysis, and more.

## Features

- **Historical Data Retrieval**: Retrieve historical commodity data for the past month with 1-minute granularity.
- **Data Formatting**: Format the retrieved data to simplify the DateTime format and select relevant columns.
- **CSV Export**: Save the formatted data to a CSV file for use in external analysis tools.

## Prerequisites

Before using this tool, ensure that you have the following dependencies installed:

- Python (3.6+)
- Pandas
- yfinance

You can install the required Python libraries using `pip`:

bash
pip install pandas yfinance


Run the script
python app.py

## CSV file format
The saved CSV file contains the following columns:

Opening Price: The opening price of the commodity within the specified time interval.
Highest Price: The highest price of the commodity during the specified time interval.
Lowest Price: The lowest price of the commodity during the specified time interval.
Closing Price: The closing price of the commodity within the specified time interval.
Trading Volume: The trading volume of the commodity during the specified time interval.

