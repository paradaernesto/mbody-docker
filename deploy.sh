#!/bin/sh

source /root/.sdkman/bin/sdkman-init.sh
./grailsw -Dgrails.env=development war /var/lib/tomcat7/webapps/embody.war
tail -f /var/lib/tomcat7/logs/catalina.out
