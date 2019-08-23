# Jenkins Docker image for ARM
The Jenkins Continuous Integration and Delivery server [available on Docker Hub](https://hub.docker.com/nazman/jenkins-armhf)

This is a fully functional Jenkins server based on 
[https://github.com/jenkinsci/docker](https://github.com/jenkinsci/docker).

<img src="https://jenkins.io/sites/default/files/jenkins_logo.png"/>
Build your own image using __build.sh__ script or use this one
```
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 nazman/jenkins-armhf
```
