# Start with a base OpenJDK 17 image
FROM openjdk:17-slim

# Install Ant and other necessary tools
RUN apt-get update && apt-get install -y \
    ant \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy your project files into the container
COPY . .

# Set default command (optional)
CMD ["ant", "compile"]
