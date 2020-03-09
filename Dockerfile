# Use the official maven/Java 8 image to create a build artifact.
FROM maven:3.5-jdk-8-alpine as builder

# Copy local code to the container image.
WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build a release artifact.
RUN mvn package

# Stage and thin the application
FROM websphere-liberty:springBoot2 as staging

COPY --chown=1001:0 --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar \
                    /staging/fat-demo-0.0.1-SNAPSHOT.jar

RUN springBootUtility thin \
 --sourceAppPath=/staging/fat-demo-0.0.1-SNAPSHOT.jar \
 --targetThinAppPath=/staging/thin-demo-0.0.1-SNAPSHOT.jar \
 --targetLibCachePath=/staging/lib.index.cache

# Build the image
FROM websphere-liberty:springBoot2

# RUN cp /opt/ol/wlp/templates/servers/springBoot2/server.xml /config/server.xml

COPY --chown=1001:0 --from=staging /staging/lib.index.cache /lib.index.cache
COPY --chown=1001:0 --from=staging /staging/thin-demo-0.0.1-SNAPSHOT.jar \
                    /config/dropins/spring/thin-demo-0.0.1-SNAPSHOT.jar

RUN configure.sh