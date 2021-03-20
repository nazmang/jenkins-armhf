#!/bin/bash

JENKINS_VERSION=2.46.1
JENKINS_USER=jenkins
JENKINS_GROUP=jenkins
JENKINS_UID=1000
JENKINS_GID=1000
JENKINS_HOME=/var/jenkins_home
JENKINS_HTTP_PORT=8080
JENKINS_AGENT_PORT=50000
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
TINI_VERSION=v0.16.1

PREFIX="nazman"
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESOURCEDIR="$BASEDIR/docker"
ARCH=${1:-armhf} 

if [ ! -d "$RESOURCEDIR" ]; then
	  mkdir $RESOURCEDIR && cd $RESOURCEDIR
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/init.groovy
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/tini_pub.gpg
	  curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/tini-shim.sh
	  curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$ARCH -o tini
	  curl -fsSL ${JENKINS_URL} -o jenkins.war
  	  chmod +rx *
	  cd $BASEDIR
fi

docker build \
	--tag $PREFIX/jenkins-$ARCH:$JENKINS_VERSION \
	--build-arg JENKINS_VERSION=$JENKINS_VERSION \
	--build-arg user=$JENKINS_USER \
	--build-arg group=$JENKINS_GROUP \
	--build-arg uid=$JENKINS_UID \
	--build-arg gid=$JENKINS_GID \
	--build-arg JENKINS_HOME=$JENKINS_HOME \
	--build-arg http_port=$JENKINS_HTTP_PORT \
	--build-arg agent_port=$JENKINS_AGENT_PORT \
	--build-arg JENKINS_SHA=$JENKINS_SHA \
	--build-arg JENKINS_URL=$JENKINS_URL \
	--build-arg TINI_VERSION=$TINI_VERSION \
	--no-cache --file Dockerfile .
	
docker tag $PREFIX/jenkins-$ARCH:$JENKINS_VERSION $PREFIX/jenkins-$ARCH:latest
docker push $PREFIX/jenkins-$ARCH:$JENKINS_VERSION
docker push $PREFIX/jenkins-$ARCH:latest
