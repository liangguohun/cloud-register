FROM openjdk:8-jdk-alpine
VOLUME /tmp
ADD eureka-server.jar app.jar
RUN sh -c 'touch /app.jar'
ENV JAVA_OPTS="-Xmx128m -Xms128m -javaagent:/app/apache-skywalking-apm-incubating/agent/skywalking-agent.jar -Dskywalking.agent.service_name=eureka-server -Dskywalking.collector.backend_service=192.168.1.5:11800"

EXPOSE 1111
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]