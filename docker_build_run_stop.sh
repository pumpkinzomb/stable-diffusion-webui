#!/bin/bash
# 실행시 파일에 대한 권한이 필요합니다. 
chmod +x "$0"

# Docker image and container names
IMAGE_NAME="stable-diffusion"
CONTAINER_NAME="stable-diffusion"
PORT_NUMBER=7860

# Function to build the Docker image
build_image() {
    docker build -t $IMAGE_NAME .
}

# Function to run the Docker container
run_container() {
    # Check if the image exists, if not, prompt user to choose from available images
    if ! docker images -q $IMAGE_NAME > /dev/null; then
        echo "No '$IMAGE_NAME' image found. Please choose from the available images:"
        docker images
        read -p "Enter the image name to use: " selected_image
        IMAGE_NAME=$selected_image
    fi

    # Run the Docker container
    docker run -p $PORT_NUMBER:5000 --name $CONTAINER_NAME $IMAGE_NAME
}

# Function to stop the Docker container
stop_container() {
    # Check if the container is running
    if docker ps -q --filter "name=$CONTAINER_NAME" > /dev/null; then
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        echo "Container '$CONTAINER_NAME' stopped and removed."
    else
        echo "Container '$CONTAINER_NAME' is not running."
    fi
}

# Function to display help
show_help() {
    echo "Usage: $0 {build|run|stop|help}"
    echo "Options:"
    echo "  build   - Build the Docker image"
    echo "  run     - Run the Docker container on port $PORT_NUMBER"
    echo "  stop    - Stop and remove the Docker container"
    echo "  help    - Show this help message"
}

# Main script logic
case "$1" in
    "build")
        build_image
        ;;
    "run")
        run_container
        ;;
    "stop")
        stop_container
        ;;
    "help")
        show_help
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac