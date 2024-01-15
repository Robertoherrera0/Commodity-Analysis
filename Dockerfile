# Use an official Python runtime as a parent image
FROM python:3.12

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install R
RUN apt-get update && \
    apt-get install -y r-base r-base-dev

# Install R packages
RUN R -e "install.packages(c('ggplot2', 'plotly', 'forecast', 'rugarch', 'htmlwidgets', 'TTR', 'dplyr', 'dygraphs', 'xts', 'quantmod'), repos='http://cran.rstudio.com/')"

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "./app.py"]
