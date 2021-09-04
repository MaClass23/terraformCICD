FROM tomcat:9.0.46-jdk11
# Dummy text to test 
COPY target/*.war /usr/local/tomcat/webapps/mamz-web-app.war
