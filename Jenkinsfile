pipeline {
	environment {
		registry = 'nazman/jenkins-armhf'
		registryCredential = 'dockerhub'
		DOCKER_BUILDKIT = '1'
		DOCKER_CLI_EXPERIMENTAL = 'enabled'
		JENKINS_VERSION = '2.235.5'
		JENKINS_USER = 'jenkins'
		JENKINS_GROUP = 'jenkins'
		JENKINS_UID = '1000'
		JENKINS_GID = '1000'
		JENKINS_HOME = '/var/jenkins_home'
		JENKINS_HTTP_PORT = '8080'
		JENKINS_AGENT_PORT = '50000'
		TINI_VERSION = 'v0.16.1'
	}
	agent any
	stages {
		stage('Build buildx') {
			steps{
				git 'git://github.com/docker/buildx'
				sh 'env'
				script {
					def buildx = docker.build ("local/buildx", "--platform=local -o . git://github.com/docker/buildx")
					buildx.run("--rm --privileged multiarch/qemu-user-static --reset -p yes i")
				}
				sh '''
					mkdir -p ~/.docker/cli-plugins && mv buildx ~/.docker/cli-plugins/docker-buildx 
					docker buildx rm
					docker buildx inspect --bootstrap 					
					docker buildx create --name multibuilder --use
				'''	
			}
		}
		stage('Clone source') { // for display purposes
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/nazmang/jenkins-armhf.git'                
            }
		}	
		stage('Preparation') {
			// Run the 
			steps {			    
				sh '''
                mkdir docker
				cd docker
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/init.groovy
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/tini_pub.gpg
                curl -sSLO https://raw.githubusercontent.com/jenkinsci/docker/master/tini-shim.sh
				curl -fsSL https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-static-armhf -o tini
				curl -fsSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$JENKINS_VERSION/jenkins-war-$JENKINS_VERSION.war -o jenkins.war
                chmod +rx *
                cd ..
                '''
			}
		}
		stage ('Build'){
			steps {		
				sh '''
				docker buildx build --platform linux/arm/v7 \
				--file ./Dockerfile.armhf --tag nazman/jenkins-armhf:$JENKINS_VERSION \
				--tag nazman/jenkins-armhf:latest \
				--build-arg JENKINS_VERSION=$JENKINS_VERSION \
				--build-arg user=$JENKINS_USER \
				--build-arg group=$JENKINS_GROUP \
				--build-arg uid=$JENKINS_UID \
				--build-arg gid=$JENKINS_GID \
				--build-arg JENKINS_HOME=$JENKINS_HOME \
				--build-arg http_port=$JENKINS_HTTP_PORT \
				--build-arg agent_port=$JENKINS_AGENT_PORT \
				--build-arg JENKINS_SHA=$JENKINS_SHA \
				--load . 
				'''	
			}
		}
		stage('Deploy Image') {
			steps{
				script {
					docker.withRegistry( '', registryCredential ) {
						sh 'docker push nazman/jenkins-armhf:$JENKINS_VERSION'
						sh 'docker push nazman/jenkins-armhf:latest'						
            		}
				}
				sh 'docker rmi nazman/jenkins-armhf:latest'
			}
		}
		
    }
}