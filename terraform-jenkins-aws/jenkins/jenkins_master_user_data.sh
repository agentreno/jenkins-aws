#!/bin/bash
set -x

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
add-apt-repository "deb https://pkg.jenkins.io/debian-stable binary/"
apt-get update
apt-get -y install default-jre
apt-get -y install jenkins
apt-get -y install jq

# Install plugins
until test -f /var/lib/jenkins/secrets/initialAdminPassword; do sleep 1; done
JENKINS_ADMIN_PASSWORD=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
checkJenkinsReady() {
    java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar \
        -s http://localhost:8080 \
        -auth admin:$JENKINS_ADMIN_PASSWORD \
        version
}
until checkJenkinsReady; do sleep 1; done

PLUGINS=("ssh-slaves" "blueocean")
for PLUGIN in "${PLUGINS[@]}"
do
	java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar \
		-s http://localhost:8080 \
		-auth admin:$JENKINS_ADMIN_PASSWORD \
		install-plugin $PLUGIN \
		-deploy
done

CSRF_TOKEN=$(curl --user "admin:$JENKINS_ADMIN_PASSWORD" -s http://localhost:8080/crumbIssuer/api/json | jq -r '. | .crumbRequestField + "=" + .crumb')

curl --user "admin:$JENKINS_ADMIN_PASSWORD" -d "$CSRF_TOKEN" --data-urlencode "script=$(</home/ubuntu/create-credential.groovy)" http://localhost:8080/scriptText
curl --user "admin:$JENKINS_ADMIN_PASSWORD" -d "$CSRF_TOKEN" --data-urlencode "script=$(</home/ubuntu/add-node.groovy)" http://localhost:8080/scriptText
