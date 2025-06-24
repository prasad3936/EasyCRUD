# Build stage
FROM maven:3.8.3-openjdk-17 AS build

WORKDIR /opt

COPY pom.xml .
COPY src ./src
COPY application.properties ./src/main/resources/application.properties

RUN mvn clean package -DskipTests
RUN ls -ltr

# Run stage
FROM openjdk:17-jdk-slim

WORKDIR /opt
RUN ls -ltr
COPY --from=build /opt/target/student-registration-backend-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "student-registration-backend-0.0.1-SNAPSHOT.jar"]



