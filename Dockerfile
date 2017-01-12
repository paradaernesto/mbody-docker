# MBODY DOCKERFILE
#LABEL version="0.1"
FROM ubuntu
MAINTAINER Ernesto Parada <ernesto.parada@patagonian.it>

EXPOSE 8080

RUN apt-get -qq update
RUN apt-get -qq upgrade

# fix error "openjdk-7-jre has no installation candidate"
RUN apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository -y ppa:openjdk-r/ppa

# fix error "delaying package configuration, since apt-utils is not installed"
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get -qq update

# INSTALL OPEN JDK 8
RUN apt-get -y install openjdk-8-jre

# INSTALL TOMCAT 7
RUN apt-get -qq install tomcat7

# INSTALL TOOLS
RUN apt-get -qq install curl
RUN apt-get -qq install bash
RUN apt-get -y install nano

ADD start-tomcat.sh /opt/start-tomcat.sh
RUN chmod +x /opt/start-tomcat.sh

#RUN mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate

#ADD logrotate /etc/logrotate.d/tomcat7
#RUN chmod 644 /etc/logrotate.d/tomcat7

# Install java JCE
ADD local_policy.jar /opt/local_policy.jar
ADD US_export_policy.jar /opt/US_export_policy.jar
#RUN mv /opt/local_policy.jar /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre/lib/security/opt/local_policy.jar
#RUN mv /opt/US_export_policy.jar /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre/lib/security/opt/US_export_policy.jar

# Setup UTF * based terminal
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# INSTALL MYSQL
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -y install mysql-server mysql-client mysql-common
RUN service mysql start
#ADD MYSQL DUMP
ADD mbody_dump.sql /opt/mbody_dump.sql

# INSTALL GRAILS
RUN apt-get -y install unzip
RUN apt-get -y install zip
RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install grails 2.4.3"

# ADD PROJECT
ADD /embody-tracker-backend /opt/embody-tracker-backend

ADD deploy.sh /opt/deploy.sh

# JAVA/TOMCAT Configuration
RUN echo '' >> /etc/default/tomcat7
RUN echo 'JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -Xmx1024m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512m"' >> /etc/default/tomcat7
RUN echo 'CATALINA_OPTS=${CATALINA_OPTS:-"-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -Djava.security.egd=file:/dev/./urandom"}' >> /etc/default/tomcat7

ENTRYPOINT ["/opt/start-tomcat.sh"]
