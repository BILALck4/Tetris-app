FROM ubuntu:latest

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

RUN apt-get update && \
    apt-get install -y ant curl && \
    apt-get clean

RUN mkdir -p /usr/local/ivy && \
    curl -L https://dlcdn.apache.org/ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz | tar xz -C /usr/local/ivy --strip-components=1 && \
    mv /usr/local/ivy/ivy-2.5.2.jar /usr/share/ant/lib/ivy.jar

# Set the classpath for Ant to recognize Ivy
ENV ANT_HOME=/usr/share/ant
ENV ANT_LIB=$ANT_HOME/lib

# Add the Ivy jar to the classpath
RUN echo "ivy.jar" >> /usr/share/ant/lib/antlib.properties


CMD ["ant"]
