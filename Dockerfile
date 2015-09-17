FROM daocloud.io/golfen/java-base

MAINTAINER Golfen Guo "golfen.guo@daocloud.io"

# Prepare by downloading dependencies
WORKDIR /code
ADD pom.xml /code/pom.xml
RUN mvn dependency:resolve

# Adding source, compile and package into a WAR
ADD src /code/src
RUN mvn -DskipTests=true package
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*
RUN cp -r target/travel-1.0.0/* $CATALINA_HOME/webapps/ROOT/

# Upload to internal Artifactory
RUN mvn deploy:deploy-file -DrepositoryId=cmb-internal -Durl=http://52.69.70.39:80/artifactory/ext-release-local -DgroupId=io.daocloud.sample -DartifactId=travel -Dversion=1.0.0 -Dpackaging=war -Dfile=/code/target/travel.war
