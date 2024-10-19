#!/bin/bash

# Define the image, backup image, and container name and port

IMAGE_NAME="vue-vite-webpack-docker-nginx-sample-app"
BACKUP_IMAGE_NAME="${IMAGE_NAME}:backup"
CONTAINER_NAME="vue-vite-webpack-container"
CONTAINER_EXPOSE_PORT=3004

# Backup the current image (if it exists)
echo "Checking if the image exists for backup..."
IMAGE_EXISTS=$(docker images -q "$IMAGE_NAME")

if [ -n "$IMAGE_EXISTS" ]; then
    # Tag the current image as a backup
    echo "Backing up the existing image as $BACKUP_IMAGE_NAME..."
    docker tag "$IMAGE_NAME" "$BACKUP_IMAGE_NAME"
else
    echo "No existing image found. Skipping backup."
fi

# Find any running containers with the specified name
RUNNING_CONTAINER_ID=$(docker ps -q --filter name="$CONTAINER_NAME")

# Stop and remove the running container, if it exists
if [ -n "$RUNNING_CONTAINER_ID" ]; then
    echo "Stopping and removing the running container: $CONTAINER_NAME"
    docker stop "$RUNNING_CONTAINER_ID"
    docker rm "$RUNNING_CONTAINER_ID"
fi

# Remove the existing image (if it exists)
if [ -n "$IMAGE_EXISTS" ]; then
    echo "Removing existing image: $IMAGE_NAME"
    docker rmi "$IMAGE_NAME"
else
    echo "No existing image to remove."
fi

# Build the new Docker image
echo "Building the Docker image..."
docker build -t "$IMAGE_NAME" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Image built successfully. Running the container..."

    # Run the Docker container with a specified name
    docker run -d -p "$CONTAINER_EXPOSE_PORT":80 --name "$CONTAINER_NAME" "$IMAGE_NAME"

    # Check the container status
    sleep 10  # Wait for a few seconds to see if the container runs properly
    CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")

    if [ "$CONTAINER_STATUS" == "running" ]; then
        echo "The new container is running successfully."
    else
        echo "The new container failed to run. Reverting to the backup image..."

        # Remove the failed container
        docker rm "$CONTAINER_NAME"

        # Check if the backup image exists
        BACKUP_EXISTS=$(docker images -q "$BACKUP_IMAGE_NAME")
        if [ -n "$BACKUP_EXISTS" ]; then
            # Restore the backup image by tagging it back to the original name
            echo "Restoring the backup image as $IMAGE_NAME..."
            docker tag "$BACKUP_IMAGE_NAME" "$IMAGE_NAME"

            # Run the backup image
            echo "Running the backup image..."
            docker run -d -p "$CONTAINER_EXPOSE_PORT":80 --name "$CONTAINER_NAME" "$IMAGE_NAME"

            BACKUP_CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")
            if [ "$BACKUP_CONTAINER_STATUS" == "running" ]; then
                echo "The backup container is running successfully."
            else
                echo "Failed to run the backup container. Manual intervention may be required."
                exit 1
            fi
        else
            echo "No backup image available to restore."
            exit 1
        fi
    fi
else
    echo "Failed to build the Docker image. Reverting to the backup image..."

    # Check if the backup image exists
    BACKUP_EXISTS=$(docker images -q "$BACKUP_IMAGE_NAME")
    if [ -n "$BACKUP_EXISTS" ]; then
        # Restore the backup image by tagging it back to the original name
        echo "Restoring the backup image as $IMAGE_NAME..."
        docker tag "$BACKUP_IMAGE_NAME" "$IMAGE_NAME"

        # Run the backup image
        echo "Running the backup image..."
        docker run -d -p "$CONTAINER_EXPOSE_PORT":80 --name "$CONTAINER_NAME" "$IMAGE_NAME"

        BACKUP_CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")
        if [ "$BACKUP_CONTAINER_STATUS" == "running" ]; then
            echo "The backup container is running successfully."
        else
            echo "Failed to run the backup container. Manual intervention may be required."
            exit 1
        fi
    else
        echo "No backup image available to restore."
        exit 1
    fi
fi
