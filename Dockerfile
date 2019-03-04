# Use an official tensorflow runtime as a parent image
FROM tensorflow/tensorflow:1.13.1-gpu-py3-jupyter

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org tensor2tensor

