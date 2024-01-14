#!/usr/bin/env python
import sys
import time
import psutil
from memory_profiler import profile
from urllib.request import urlopen
import certifi
import json
import csv

def main(symbol):
    start_time = time.time()
    def get_jsonparsed_data(url):
        response = urlopen(url, cafile=certifi.where())
        data = response.read().decode("utf-8")
        return json.loads(data)
    
    print(symbol)

    # fullquote = (f"https://financialmodelingprep.com/api/v3/quote/{symbol}?apikey=7P01sI2C4YmgpFt8dJDWUAtjpFr5Rlp9")
    daily = (f"https://financialmodelingprep.com/api/v3/historical-price-full/{symbol}?apikey=7P01sI2C4YmgpFt8dJDWUAtjpFr5Rlp9")

    # data = get_jsonparsed_data(fullquote)
    data3 = get_jsonparsed_data(daily)


    # with open('commodity_data.csv', mode='w', newline='') as file:
    #     writer = csv.writer(file)

    #     # Write the header row
    #     header = data[0].keys()
    #     writer.writerow(header)

    #     # Write the data rows
    #     for row in data:
    #         writer.writerow(row.values())

    with open('R/daily.csv', mode='w', newline='') as file2:
        writer = csv.writer(file2)

        # Write the header row
        header = data3['historical'][0].keys()
        writer.writerow(header)

        # Write the data rows
        for row in data3['historical']:
            writer.writerow(row.values())

    # Close the CSV file
    # file.close()
    file2.close()


    print('Data files created.')


    end_time = time.time()
    execution_time = end_time - start_time

    print(f"Execution Time: {execution_time} seconds")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        symbol = sys.argv[1]
    else:
        print("No commodity selected. Exiting.")
        sys.exit(1)

    process = psutil.Process()
    print(f"CPU Usage Before Execution: {process.cpu_percent(interval=1)}%")
    print(f"Memory Usage Before Execution: {process.memory_info().rss / 1024 / 1024} MB")
    main(symbol)
    print(f"CPU Usage After Execution: {process.cpu_percent(interval=1)}%")
    print(f"Memory Usage After Execution: {process.memory_info().rss / 1024 / 1024} MB")
    print(symbol)