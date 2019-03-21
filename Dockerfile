# Use official tensorflow image
FROM tensorflow/tensorflow:1.13.1-gpu-py3

# Set the working directory to /wikisum
WORKDIR /home/wikisum

# Copy requirements file into the container WORKDIR
COPY requirements.txt /home/wikisum

# Install dependencies:
RUN pip uninstall protobuf -y && pip install -r requirements.txt

# Cleanup:
RUN rm requirements.txt

