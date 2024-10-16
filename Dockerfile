# Use an Alpine base image
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy project files into the image
COPY . .

# Set environment variables for Ivy
ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Install required packages
RUN apk add --no-cache openjdk17 curl bash wget unzip

# Install Apache Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.12-bin.zip && \
    unzip apache-ant-1.10.12-bin.zip && \
    mv apache-ant-1.10.12 /usr/local/apache-ant && \
    ln -s /usr/local/apache-ant/bin/ant /usr/bin/ant && \
    rm apache-ant-1.10.12-bin.zip

# Create Ivy home directory
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar /usr/local/apache-ant/lib/ivy.jar

# Update CLASSPATH to include Ivy
ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Run Ant to build the project
RUN ant all

# Command to run the application (optional)
CMD ["java", "-jar", "bin/Tetris.jar"]
