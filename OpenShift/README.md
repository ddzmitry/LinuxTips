# minishift start --vm-driver=virtualbox

#### OpenShift server started.

* The server is accessible via web console at:
>     https://192.168.99.101:8443/console

* You are logged in as:
>    User:     developer
>     Password: <any value>

* To login as administrator:
 > oc login -u system:admin

 #### To get token for API
 > oc login 
 > developer : password
 > oc whoami -t
 > curl http://localhost:8443/oapi/v1/users \ -H "Authorization: Bearer `output from oc whoami -t` "

#### Use REST
```bash
 curl -X GET -H "Authorization: Bearer viyza0oQc4fdwrVGUSBfwY6C7_fOCtcuv64UjGywPNw " https://192.168.99.101:8443/oapi/v1 --insecure
```

#### Users
> Regular User
> System user 
> Service Accounts

#### Using OC 
```
> Login 
oc login -u system:admin
> Get Users 
oc get users
> Get Projects
oc get projects
> To give user super privileges
oc adm policy add-cluster-role-to-user cluster-admin administrator

```

### Image Streams and Docker
```
> Local Registry
Pushing image 172.30.1.1:5000/my-web-application/simple-web-app:latest
```

#### Create Image Stream First (BUILDS copy from images )

![Create Image Stream Build](Image_Streams/1_create_name.png)

```yaml
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  annotations:
    openshift.io/generated-by: OpenShiftWebConsole
  creationTimestamp: '2020-01-25T22:25:12Z'
  generation: 1
  labels:
    app: simple-webapp-docker
  name: simple-webapp-docker
  namespace: my-web-application
  resourceVersion: '40083'
  selfLink: >-
    /apis/image.openshift.io/v1/namespaces/my-web-application/imagestreams/simple-webapp-docker
  uid: 8d866697-3fc1-11ea-9986-0800271920dc
spec:
  lookupPolicy:
    local: false
status:
  dockerImageRepository: '172.30.1.1:5000/my-web-application/simple-webapp-docker'

```
#### Add to project -> Select YAML/JSON option -> Upload Docker-Stream-app.yml -> Run
![Upload Stream](Image_Streams/2_create_and_pull_image.png) 

```yaml
apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: simple-webapp-docker
spec:
  output:
    to:
    # Make sure ImageStream is configured 
      kind: ImageStreamTag
      name: 'simple-webapp-docker:latest'
  runPolicy: Serial
  source:
    git:
      ref: master
      uri: 'https://github.com/mmumshad/simple-webapp-docker'
    type: Git
  strategy:
    # Changed to Docker Streategy
    dockerStrategy:
    # Make sure we have docker image in REPO    
    type: Docker
  triggers:
    - imageChange:
        lastTriggeredImageID: >-
          172.30.1.1:5000/openshift/python@sha256:e1e6c06dca6ccf6ec30f2bee25926b21607f399d9b0b59ea37fd8ec3b940b3bd
      type: ImageChange
    - type: ConfigChange
    - generic:
        secret: b1117f5b9ea90229
      type: Generic
    - github:
        secret: edc45e13735bed33
      type: GitHub
status:
  lastVersion: 1
```

#### Use Image Streams to Deply
![Deply Image](Image_Streams/3_Use_ImageStream_to_deploy.png))

#### Check Active Deployments 
![Check Active Deployments](Image_Streams/4_active_deplyments.png)
#### See running app
![Check Running app](Image_Streams/5_Running_app.png)
```
oc start-build simple-webapp-docker -n my-web-application
```


```
oc expose service docker-registry -n default
route.route.openshift.io/docker-registry exposed
> sudo docker tag 51f544a725fc 172.30.1.1:5000/pushed/myimage:latest
> sudo docker push 172.30.1.1:5000/pushed/myimage:latest
> Local Registry  172.30.1.1:5000/my-web-application/simple-webapp-docker
```
https://blog.openshift.com/remotely-push-pull-container-images-openshift/



#### Webhooks
> Inside of Editbuilds you can create webhooks for bitbucket
