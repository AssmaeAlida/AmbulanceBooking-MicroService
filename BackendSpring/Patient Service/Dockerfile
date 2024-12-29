FROM eclipse-temurin:17-jdk
VOLUME /tmp
ADD target/your-app.jar app.jar
EXPOSE 8085
ENTRYPOINT ["java","-jar","/app.jar"]

# Mount the Firebase service account file
COPY serviceAccountKey.json /app/serviceAccountKey.json
