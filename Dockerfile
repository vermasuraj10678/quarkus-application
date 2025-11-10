####
# This Dockerfile is used to build a native container image for the Quarkus application using GraalVM
# It uses a multi-stage build to create a minimal production image
####

# Stage 1: Build native image with GraalVM
FROM quay.io/quarkus/ubi-quarkus-mandrel-builder-image:jdk-21 AS build

USER root
RUN microdnf install -y maven && microdnf clean all

USER quarkus
WORKDIR /build

# Copy pom.xml and download dependencies (better layer caching)
COPY --chown=quarkus:quarkus pom.xml .
RUN mvn dependency:resolve -Pnative

# Copy source code and build the native image
COPY --chown=quarkus:quarkus src ./src
RUN mvn package -Pnative -DskipTests -Dmaven.test.skip=true

# Stage 2: Create the minimal runtime image
FROM quay.io/quarkus/quarkus-micro-image:2.0
WORKDIR /app

# Copy the native executable from build stage
COPY --from=build /build/target/*-runner /app/application

# Set proper permissions
RUN chmod 775 /app/application

# Set the application port
EXPOSE 8080

# Run the native application
CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
