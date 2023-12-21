# Use an official Python runtime as a base image
FROM python:latest

# Set the working directory in the container to /app
WORKDIR /app

# Install system dependencies for R and Python
RUN apt-get update && apt-get install -y \
    r-base \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libz-dev \
    libcairo2-dev \
    libxt-dev

# Install R packages
RUN R -e "install.packages('jsonlite', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('dygraphs', dependencies=TRUE, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('xts', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('tidyverse', dependencies=TRUE, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('lubridate', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('htmlwidgets', repos='https://cloud.r-project.org/')"

# Copy the Python requirements file into the container
COPY requirements.txt /app/
# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code into the container
COPY . /app

# Make port 5000 available outside this container
EXPOSE 5000

# Define environment variable
ENV NAME World

# Command to run the Flask app
CMD ["python", "app.py"]
