#!/usr/bin/env python
try:
    # For Python 3.0 and later
    from urllib.request import urlopen
except ImportError:
    # Fall back to Python 2's urllib2
    from urllib2 import urlopen
import certifi
import json
from flask import Flask, render_template, request, jsonify
import subprocess

def get_jsonparsed_data(url):
    response = urlopen(url, cafile=certifi.where())
    data = response.read().decode("utf-8")
    return json.loads(data)


app = Flask(__name__, template_folder='web', static_folder='web')

@app.route('/', methods=['GET', 'POST'])
def index():
    plot = False

    menu = ("https://financialmodelingprep.com/api/v3/symbol/available-commodities?apikey=7P01sI2C4YmgpFt8dJDWUAtjpFr5Rlp9")
    commodities = get_jsonparsed_data(menu)
    tickers = [(commodity['name'], commodity['symbol']) for commodity in commodities]

    if request.method == 'POST':
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':

            selected_commodity = request.form['selectedCommodity']

            # Run the Python data fetching script
            subprocess.run(['python', 'dataAPI.py', selected_commodity])

            # Run the R scripts for analysis
            subprocess.run(['Rscript', 'R/arima_garch.R'])
            subprocess.run(['Rscript', 'R/candlestick.R'])
            subprocess.run(['Rscript', 'R/barchart.R'])
            subprocess.run(['Rscript', 'R/strawbroom.R'])

            plot = True
            return jsonify(plot=plot, commodities=tickers)  # Send a response indicating the plot is ready
        else:
            # Normal request handling
            return render_template('index.html', plot=plot, commodities=tickers)
    else:
        # GET request
        return render_template('index.html', plot=plot, commodities=tickers)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')