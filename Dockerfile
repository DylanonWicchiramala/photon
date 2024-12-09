# Use OpenJDK as the base image
FROM openjdk:11-jdk-slim

# Set environment variables
ENV PHOTON_VERSION=0.6.1
ENV PHOTON_PORT=2322
ENV DATA_DIR=/app/photon_data

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    pbzip2 \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Download and prepare the Photon data
RUN wget -O - https://download1.graphhopper.com/public/photon-db-latest.tar.bz2 | pbzip2 -cd | tar x -C /app

# Copy project files (assuming your project source is in the current directory)
COPY . /app

# Build the Photon JAR using Gradle
RUN ./gradlew app:es_embedded:build

# Expose the port for Photon API
EXPOSE $PHOTON_PORT

# Set the command to run Photon
CMD ["java", "-jar", "target/photon-*.jar", "-data-dir", "/app/photon_data"]