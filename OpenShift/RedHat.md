
## Get main stuff
```
oc get all 
oc login username:password 
oc get route name () 
oc project
oc whoami
oc get svc name
```
```
user17:
oc login -u user17 --insecure-skip-tls-verify=true \
https://lab:6443


oc get serviceaccounts
oc get secrets
oc get events
oc describe pod dotnet-1-gbkdc
oc describe service dotnet
oc describe deploymentconfig dotnet
oc describe buildconfig dotnet
```

#### get logs for pod
```
oc logs dotnet-1-gbkdc
```
#### login to pod
```
oc rsh  dotnet-1-gbkdc
```
####  Delete pod 
```
oc delete pod dotnet-1-gbkdc
```
#### get pods 
```
oc get pods
```
#### Edit pods 
```
oc edit dc dotnet
```
#### Get pods widly
```
oc get pods -w
```
#### Scale and add Replicas
```
oc scale --replicas=3 dc dotnetoc get pods
```
#### Working with repos 

https://github.com/ddzmitry/dotnet-sdg-heist
https://github.com/redhat-developer/s2i-dotnetcore-ex.git


git config --global user.email "you@example.com"git config --global user.name "Your Name"git config --global push.default simple

#### Create App from repo
```
oc new-project user17-new-app

oc new-app  dotnet:2.1~https://github.com/ddzmitry/dotnet-sdg-heist --context-dir=/app
```
#### expose app 
```
oc expose svc dotnet-sdg-heist
```

### To rebuild an application 
```
oc start-build buildconfig.build.openshift.io/dotnet-sdg-heist
```

### Exercise 7:  Deploying Jenkins to Support a CI/CDPipeline
```
oc new-project user17-dotnet-jenkins-build
oc new-project user17-dotnet-jenkins-dev
oc new-project user17-dotnet-jenkins-stage
oc new-project user17-dotnet-jenkins-prod
```

#### Deploy Jenkisn-Ephemeral
oc process openshift//jenkins-ephemeral \| oc apply -f - -n​​ user17-dotnet-jenkins-build
### Deploy in one line 
oc process openshift//jenkins-ephemeral \
| oc apply -f - -n​​ user17-dotnet-jenkins-build
### Deploy with picking up a namespace (project)
oc project user17-dotnet-jenkins-build
> **-f -** - Means get it from standard out of the oc process
oc process openshift//jenkins-ephemeral | oc apply -f -

```bash

cd ~/container-pipelines/basic-dotnet-core

oc process -f .openshift/templates/deployment.yml -p APPLICATION_NAME=user17-dotnet-jenkins  -p NAMESPACE=user17-dotnet-jenkins-dev -p SA_NAMESPACE=user17-dotnet-jenkins-build -p READINESS_PATH="/" -p READINESS_RESPONSE="status.:.UP" | oc apply -f -

oc process -f .openshift/templates/deployment.yml -p APPLICATION_NAME=user17-dotnet-jenkins -p NAMESPACE=user17-dotnet-jenkins-stage -p SA_NAMESPACE=user17-dotnet-jenkins-build -p READINESS_PATH="/" -p READINESS_RESPONSE="status.:.UP" | oc apply -f -

oc process -f .openshift/templates/deployment.yml -p APPLICATION_NAME=user17-dotnet-jenkins -p NAMESPACE=user17-dotnet-jenkins-prod -p SA_NAMESPACE=user17-dotnet-jenkins-build -p READINESS_PATH="/" -p READINESS_RESPONSE="status.:.UP" | oc apply -f -

oc process -f .openshift/templates/build.yml -p APPLICATION_NAME=user17-dotnet-jenkins -p NAMESPACE=user17-dotnet-jenkins-build -p SOURCE_REPOSITORY_URL="https://github.com/redhat-cop/container-pipelines.git" -p APPLICATION_SOURCE_REPO="https://github.com/redhat-developer/s2i-dotnetcore-ex.git" | oc apply -f -
```

#### Exercise 8:  Manually Building a dotNet CoreContainer Image
```bash
cd $HOME/s2i-dotnetcore-ex/app
dotnet restore -r rhel.7-x64
dotnet publish -f netcoreapp2.1 -c Release -r rhel.7-x64 --self-contained false /p:PublishWithAspNetCoreTargetManifest=false
```
#### Create Dockerfile 
```bash
FROM registry.access.redhat.com/dotnet/dotnet-21-runtime-rhel7:latest
ADD app/bin/Release/netcoreapp2.1/rhel.7-x64/publish/. .
CMD [ "dotnet", "app.dll" ]
``` 
#### Creat Project 
```bash
oc new-project user17-dotnet-image
```
#### Build Docker Image 
```
docker build -t image-registry-openshift-image-registry/user17-dotnet-image/dotnet-ex:latest .
```
### Fort python app 
```bash
docker build -t image-registry-openshift-image-registry/user17-python-app/python-app:latest .
```

### PUSH IMAGE
```
docker push image-registry-openshift-image-registry/user17-python-app/python-app:latest
```
### Create app 
```
oc project projectname (PROJECT -> APP)
oc new-app --image-stream=python-app (IMAGE NAME)
```

### get Your Credential
```
oc whoami -t 
docker login -u user17 -p <token> image-registry-openshift-image-registry

docker push image-registry-openshift-image-registry/user17-dotnet-image/dotnet-ex:latest


```
#### get templates 
```
oc get templates -n openshift 
oc get templates nameoftetamplae  -o yaml -n openshift 
```


#### helpfull docs 
https://gitlab.com/cmeidlin/openshift-gitlab-runner
