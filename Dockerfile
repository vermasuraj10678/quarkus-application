####
# This Dockerfile builds the Quarkus application as a native executable using GraalVM
# It uses the official Quarkus multistage build approach
####

## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/ubi-quarkus-mandrel-builder-image:jdk-21 AS build

# Install a newer version of Maven manually
USER root
RUN curl -L https://archive.apache.org/dist/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz | tar -xz -C /opt \
    && ln -s /opt/apache-maven-3.9.5 /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/local/bin/mvn

COPY --chown=quarkus:quarkus . /code
WORKDIR /code
USER quarkus

# Build the native executable
RUN mvn -B org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline -Pnative
RUN mvn package -Pnative -DskipTests

## Stage 2 : create the final image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9
WORKDIR /work/
RUN chown 1001 /work \
    && chmod "g+rwX" /work \
    && chown 1001:root /work
COPY --from=build --chown=1001:root /code/target/*-runner /work/application

EXPOSE 8080
USER 1001

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
