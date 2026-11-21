
FROM maven:3.8.8-eclipse-temurin-8 AS builder

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:8-jre

WORKDIR /app

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/config-server-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8888

ENTRYPOINT ["java", "-jar", "app.jar"]
