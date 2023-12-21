from flask import Flask, render_template, request, redirect, send_from_directory, url_for
import subprocess
import os

app = Flask(__name__, template_folder='web', static_folder='web')

@app.route('/', methods=['GET', 'POST'])
def index():
    plot=False

    if request.method == 'POST':
        ticker = request.form.get('ticker')
        
        # Run the Python data fetching script
        subprocess.run(['python', 'data_fetch.py', ticker])

        # Run the R script for analysis, passing the CSV filename as an argument
        subprocess.run(['Rscript', 'analysis.R'])

        plot = True

    return render_template('index.html', plot = plot)



if __name__ == '__main__':
   app.run(debug=True, host='0.0.0.0')