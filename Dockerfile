FROM openjdk:8-jdk-alpine
ADD target/cloud-register.jar app.jar
RUN sh -c 'touch /app.jar'
ENV JAVA_OPTS="-Xmx128m -Xms128m"

EXPOSE 1111
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]