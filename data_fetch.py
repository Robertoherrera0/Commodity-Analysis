import sys
import yfinance as yf
from datetime import datetime, timedelta
import pandas as pd

def fetch_past_month_commodity_data(ticker):
    end_date = datetime.today()
    start_date = end_date - timedelta(days=56)
    
    commodity_etf = yf.Ticker(ticker)
    data = pd.DataFrame()  # Initialize an empty DataFrame to store data
    
    # Retrieve data in 7-day chunks and concatenate the results
    while start_date < end_date:
        next_date = start_date + timedelta(days=7)
        if next_date > end_date:
            next_date = end_date  # Adjust the end date for the last request
        chunk_data = commodity_etf.history(period="1d", interval="30m", start=start_date, end=next_date)
        data = pd.concat([data, chunk_data])
        start_date = next_date + timedelta(days=1)
    
    return data

def format_data(data):
    # Convert index to datetime and then format it
    data.index = pd.to_datetime(data.index)
    data.index = data.index.strftime('%Y-%m-%d %H:%M:%S')
    
    # Select relevant columns
    data = data[['Open', 'High', 'Low', 'Close', 'Volume']]
    data.columns = ['Opening Price', 'Highest Price', 'Lowest Price', 'Closing Price', 'Trading Volume']
    data = data.round(2)  # Round numeric values
    return data

def main(ticker):
    data = fetch_past_month_commodity_data(ticker)
    formatted_data = format_data(data)
    
    csv_filename = "data.csv"
    formatted_data.to_csv(csv_filename, index=True)  # Exclude the index column

    print(f"Data for {ticker} saved to {csv_filename}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python data_fetch.py <ticker>")
        sys.exit(1)
    main(sys.argv[1])