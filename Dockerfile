# Use a base image with Python and other dependencies
FROM python:3.9

# Set the working directory
WORKDIR /app

# Create a non-root user
RUN useradd -ms /bin/bash appuser

# Copy the contents of the stable-diffusion-webui directory to the container
COPY . /app

# Change ownership to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install -r requirements.txt  # Replace with the actual requirements file if available

# Expose the port on which your web application will run (replace with the actual port)
EXPOSE 5000

# Define the command to run your application
CMD ["bash", "webui.sh"]