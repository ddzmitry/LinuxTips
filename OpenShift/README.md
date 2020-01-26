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
https://docs.openshift.com/enterprise/3.0/install_config/install/docker_registry.html


#### Webhooks
> Inside of Editbuilds you can create webhooks for bitbucket


#### Login to OpenShift minishift registry
https://docs.okd.io/latest/minishift/getting-started/quickstart.html
> docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
#### CONNECT DOCKER TO REGISTRY 
https://docs.okd.io/latest/minishift/using/docker-daemon.html
> get docker synched with minishift 
```
minishift docker-env

export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="/Users/john/.minishift/certs"
export DOCKER_API_VERSION="1.24"
# Run this command to configure your shell:
# eval $(minishift docker-env)
```

### Auth Yourself
```
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)

dzmitrydubarau@Dzmitrys-MacBook-Pro simple-webapp-docker % docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Login Succeeded
```
### Check if all good
```

docker ps

dzmitrydubarau@Dzmitrys-MacBook-Pro simple-webapp-docker % docker push 172.30.1.1:5000/my-web-application/simple-webapp-docker:latest
```

### Creating new application 
https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.
```
> From local registry 
docker login -u administrator -p $(oc whoami -t) $(minishift openshift registry)
docker tag 8a28ab6230f1 172.30.1.1:5000/my-web-application/nodeapptest
docker push 172.30.1.1:5000/my-web-application/nodeapptest
oc new-app 172.30.1.1:5000/my-web-application/nodeapptest
oc new-app my-web-application/nodeapptest --name=nodeapptest
oc expose svc/nodeapptest
```
#### Update Code 
```
docker tag cdc8f05823c9 172.30.1.1:5000/my-web-application/nodeapptest:latest
docker push 172.30.1.1:5000/my-web-application/nodeapptest:latest
oc rollout latest dc/nodeapptest -n my-web-application
```

#### Check the history
```
oc rollout latest dc/nodeapptest
oc rollout history dc/nodeapptest
REVISION        STATUS          CAUSE
1               Complete        config change
2               Complete        manual change
3               Complete        manual change
4               Complete        manual change
5               Complete        manual change

oc rollout describe dc nodeapptest
oc rollout undo dc/nodeapptest (roll back deployment)
```

## Creating Deployment Ex:
https://docs.okd.io/latest/dev_guide/deployments/how_deployments_work.html

> nodeapptest - IMAGE NAME 

```yaml
kind: "DeploymentConfig"
apiVersion: "v1"
metadata:
  name: "nodeapptest"
spec:
  template: 
    metadata:
      labels:
        name: "nodeapptest"
    spec:
      containers:
        - name: "nodeapptest"
          image: "nodeapptest:latest"
          ports:
            - containerPort: 8080
              protocol: "TCP"
  replicas: 1 
  triggers:
    - type: "ConfigChange" 
    - type: "ImageChange" 
      imageChangeParams:
        automatic: true
        containerNames:
          - "nodeapptest"
        from:
          kind: "ImageStreamTag"
          name: "nodeapptest:latest"
  strategy: 
    type: "Rolling"
  paused: false 
  revisionHistoryLimit: 2 
  minReadySeconds: 0 
```
### Go to builds -> Deploy YAML/JSOM
> now since type is Rolling we can update code and it will redeploy image

```
docker tag b4f4b4b1e0ac 172.30.1.1:5000/my-web-application/nodeapptest:latest
docker push 172.30.1.1:5000/my-web-application/nodeapptest:latest
oc rollout latest dc/nodeapptest2 -n my-web-application
oc rollout latest dc/nodeapptest -n my-web-application
oc rollout latest dc/nodeapptest(ANY DEPLOYMENT) -n my-web-application
```

## Creating Service 
> Go to Services Deploy YAML
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeapptest-docker     
spec:
  selector:
    deploymentconfig: nodeapptest-docker
    # IP WILL ASSIGN AUTOMATICALLY
  ports:
  - name: 8080-tcp
    port: 8080               
    protocol: TCP
    targetPort: 8080         
```
> Go to Routes and Create ROUTE 
> Change YAML
```
haproxy.router.openshift.io/balance: roundrobin
haproxy.router.openshift.io/disable_cookies: 'true'
```
```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  annotations:
    haproxy.router.openshift.io/balance: roundrobin
    haproxy.router.openshift.io/disable_cookies: 'true'
    openshift.io/host.generated: 'true'
  creationTimestamp: '2020-01-26T08:30:05Z'
  labels:
    app: nodeapptest2
  name: route2
  namespace: my-web-application
  resourceVersion: '201896'
  selfLink: /apis/route.openshift.io/v1/namespaces/my-web-application/routes/route2
  uid: 0d9f0261-4016-11ea-9986-0800271920dc
```
