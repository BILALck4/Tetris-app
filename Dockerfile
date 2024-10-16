FROM alpine:latest

WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Define environment variables for Ivy
ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Define environment variables for Ant
ENV ANT_VERSION=1.10.12
ENV ANT_HOME=/usr/local/apache-ant
ENV PATH=$PATH:$ANT_HOME/bin

# Install Java, curl, and other necessary tools
RUN apk add --no-cache openjdk17 curl bash wget unzip

# Download and install Apache Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.zip && \
    unzip apache-ant-${ANT_VERSION}-bin.zip && \
    mv apache-ant-${ANT_VERSION} $ANT_HOME && \
    rm apache-ant-${ANT_VERSION}-bin.zip

# Create Ivy directory and install Ivy
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $ANT_HOME/lib/ivy.jar  # Move Ivy to Ant's lib directory

# Set the classpath for Ivy
ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Validate the installation
RUN ant -version && java -version

# Optionally: Run any other Ant commands if needed
# RUN ant all
