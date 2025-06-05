# Use official Tomcat base image
FROM tomcat:9.0-jdk11

# Remove default webapps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Create folders for the webapp
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Copy web.xml
COPY WEB-INF/web.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/

# Copy servlet source and compile it inside the container
COPY src/HelloServlet.java /tmp/

# Install javac to compile servlet
RUN apt-get update && apt-get install -y openjdk-11-jdk && \
    javac -classpath /usr/local/tomcat/lib/servlet-api.jar -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes /tmp/HelloServlet.java && \
    rm /tmp/HelloServlet.java && apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose Tomcat port
EXPOSE 8080

# Run Tomcat server
CMD ["catalina.sh", "run"]
