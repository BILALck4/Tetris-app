FROM alpine:latest

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar
ENV ANT_HOME=/usr/local/apache-ant
ENV PATH=$PATH:$ANT_HOME/bin

RUN apk add --no-cache openjdk17 curl bash wget unzip

RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.12-bin.zip && \
    unzip apache-ant-1.10.12-bin.zip && \
    mv apache-ant-1.10.12 /usr/local/apache-ant && \
    rm apache-ant-1.10.12-bin.zip

RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $ANT_HOME/lib/ivy.jar  # Move Ivy to Ant's lib directory

ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Optional: Validate the installation (you can comment this out later)
RUN ant -version

RUN ant all
