#!/bin/sh


if [ -f /deployment/init.sh ];
then
	echo "Running custom init script"
	chmod +x /deployment/init.sh
	/deployment/init.sh
fi

if [ -d /deployment ];
then
	echo "Mapping deployed wars"
	rm -rf /var/lib/tomcat7/webapps
	ln -s /deployment /var/lib/tomcat7/webapps
fi

if [ -n "${Xmx}" ];
then
	sed -i s/Xmx.*\ /Xmx${Xmx}\ /g /etc/default/tomcat7
fi

if [ -n "${JAVA_OPTS}" ];
then
	# Add any Java opts that are set in the container
	echo "Adding JAVA OPTS"
	echo "JAVA_OPTS=\"\${JAVA_OPTS} ${JAVA_OPTS} \"" >> /etc/default/tomcat7
fi

chown tomcat7:tomcat7 /deployment
service tomcat7 restart

#Override the exit command to prevent accidental container distruction 
echo 'alias exit="echo Are you sure? this will kill the container. use Ctrl + p, Ctrl + q to detach or ctrl + d to exit"' > ~/.bashrc

#Config Mysql
service mysql restart
mysql -uroot -proot -e "create database embody_tracker character set utf8 collate utf8_unicode_ci"
mysql -uroot -proot embody_tracker < /opt/mbody_dump.sql

#JCE install
mv /opt/local_policy.jar /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/local_policy.jar
mv /opt/US_export_policy.jar /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/US_export_policy.jar

#init sdkman
source /root/.sdkman/bin/sdkman-init.sh

#Set JAVA_HOME
export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"

chmod +x /opt/embody-tracker-backend/deploy.sh

#Run bash to keep container running and provide interactive mode
bash
