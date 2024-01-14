# Use an official Python runtime as a parent image with R pre-installed
FROM r-base:latest

# Install Python
RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    apt-get clean

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements.txt file and install Python dependencies
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app

# Install R dependencies
RUN R -e "install.packages(c('forecast', 'reactable', 'htmlwidgets', 'dplyr', 'dygraphs', 'xts'), repos='http://cran.rstudio.com/')"

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable to inform the operating system where to look for the executables
ENV PATH /usr/local/bin:$PATH

# Run app.py when the container launches
CMD ["python3", "app.py"]
