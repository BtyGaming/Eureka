# Build stage
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Set encoding environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Copy pom first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build with explicit encoding
COPY src ./src
RUN mvn clean package -DskipTests -Dfile.encoding=UTF-8 -Dproject.build.sourceEncoding=UTF-8

# Run stage
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Copy jar from build stage
COPY --from=builder /build/target/*.jar app.jar

# Expose gateway port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]