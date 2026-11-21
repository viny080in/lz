
# Java 8 runtime base image
FROM eclipse-temurin:8-jre

# Maintainer information
LABEL maintainer="anas.tayaagi@gmail.com"

# Working directory
WORKDIR /opt

# Temporary volume
VOLUME /tmp

# Expose Forex Service port
EXPOSE 8098

# Application JAR file
ARG JAR_FILE=target/Spring-Boot-Micro-Forex-Service-0.0.1-SNAPSHOT.jar

# Copy application JAR
COPY ${JAR_FILE} /opt/forex-image.jar

# Start Spring Boot application
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/opt/forex-image.jar"]
