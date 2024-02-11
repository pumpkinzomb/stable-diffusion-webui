# Use a base image with Python and other dependencies
FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# Set the working directory
WORKDIR /app

# Create a non-root user
RUN useradd -ms /bin/bash appuser

# Copy the contents of the stable-diffusion-webui directory to the container
COPY . /app

# Switch back to root to perform apt-get operations
USER root

# Install git, Python 3, pip, curl, and gpg
RUN apt-get update && \
    apt-get install -y git python3 python3-pip curl gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up NVIDIA Container Toolkit
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up NVIDIA Container Toolkit for arm64
RUN distribution=$(. /etc/os-release; echo $ID$VERSION_ID) && \
    ARCH=$(dpkg --print-architecture) && \
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-runtime-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nvidia-container-runtime-keyring.gpg] https://nvidia.github.io/nvidia-container-runtime/ ${distribution}/$ARCH/" > /etc/apt/sources.list.d/nvidia-container-runtime.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nvidia-container-toolkit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install CUDA and cuDNN
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcudnn8=8.0.5.39-1+cuda11.0 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to the non-root user
USER appuser

# Install Python dependencies
RUN pip3 install -r requirements.txt  # Replace with the actual requirements file if available

# Expose the port on which your web application will run (replace with the actual port)
EXPOSE 7860

# Define the command to run your application
CMD ["bash", "webui.sh"]