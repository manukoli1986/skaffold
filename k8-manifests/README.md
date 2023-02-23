# Project Details

> This is a project to build Flask app using python flask framework and deploy it on Kubernetes cluster


Overview:
1. Implemented dockerize microservices with version tagging running on Python Flask.
2. Build flask based application 
3. Deployed the solution on a K8 cluster which is running on EC2 master and worker nodes. 
4. K8-Cluster is setup by Ansible playbooks
5. EC2 Provision is done by terraform code. 
6. Exposed services via LoadBalancers to acess the application via Curl. 
7. Implemented the Istio service mesh as well. 
8. Will Use Jenkins For CI process and ArgoCD for automate the deployment.
9. We will use Linkerd service mesh with Canary Deployment 


NOTE: 
1. We can deploy the same on Production as well with pod per node define if we want to run a pod on a single node. Either KOPS or Kubeadm, we can create a cluster on cloud provider using KOPS or ON-Premis using Kubeadm. The same can be deployed on production as well.
2. We can use helm manager to install Python Flask App and upgrading the same. 


# Used Kubectl to deploy the application with canary deployment strategy. 
A canary deployment is an upgraded version of an existing deployment, with all the required application code and dependencies. It is used to test out new features and upgrades to see how they handle the production environment. When we add the canary deployment to a Kubernetes cluster, it is managed by a service through selectors and labels. The amount of traffic that the canary gets corresponds to the number of pods it spins up. With both deployments set up, we monitor the canary behavior to see whether any issues arise. Once we are happy with the way it is handling requests, we can upgrade all the deployments to the latest version.

Let's Begin to setup the cluster on EC2 by cloning the code <Github URL>

```bash
$ git clone <GIT URL>
$ cd aws
$ terraform apply -auto-approve
$ cd ../ansbile
$ sh +x ./runMe.sh
```

Login to EC2 and run Deployment 
```bash
$ ssh-ec2 ec2-user@35.154.94.47
Last login: Thu Feb 23 08:08:57 2023

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-172-31-38-97 ~]$ sudo su - 
[root@ip-172-31-38-97 ~]$ su - kube
[kube@ip-172-31-38-97 ~]$ kubectl get pods -A

```



### This project consist of two steps:
1. Created two dockerized microservices with version tagging using alpine python as base image and used flask framework to provide Restapi "/image" endpoints.

a. Flasp-app1 & Dockerfile & Build images with version

#### Task 1
$ cat flask-app1/app.py
```bash
#!/usr/bin/env python3
#Importing module of flask framework to run app on web
from flask import Flask, render_template
import datetime


# Create the application.
#!/usr/bin/env python3
#Importing module of flask framework to run app on web
from flask import Flask
import datetime


# Create the application.
app = Flask(__name__)


# Displays the index page accessible at '/'
@app.route("/")
def index():
    return "Hello World !!! - v1"


# This code is finish and ready to server on port 80
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
```

```bash
$ docker login 
```


```bash
$ docker build -t manukoli1986/datatonics:v1 .
Sending build context to Docker daemon   12.8kB
Step 1/6 : FROM frolvlad/alpine-python3
latest: Pulling from frolvlad/alpine-python3
63b65145d645: Pull complete 
7ea42724e07f: Pull complete 
Digest: sha256:bb012c6df862247ca8f9438bd031d40e5fb3043669fb7e704b0d65d5f71e84ac
Status: Downloaded newer image for frolvlad/alpine-python3:latest
 ---> def6a48ceb7b
Step 2/6 : EXPOSE 80
 ---> Running in 3dd4a072b944
Removing intermediate container 3dd4a072b944
 ---> 539317d2cc5b
Step 3/6 : WORKDIR /usr/src/app
 ---> Running in 974fa05d6abf
Removing intermediate container 974fa05d6abf
 ---> a5797c1705f8
Step 4/6 : COPY . ./
 ---> 0640928c6e5a
Step 5/6 : RUN pip3 install --no-cache-dir -r requirements.txt
 ---> Running in 119052d7ea82
Collecting Flask
  Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 2.4 MB/s eta 0:00:00
Collecting click>=8.0
  Downloading click-8.1.3-py3-none-any.whl (96 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 10.3 MB/s eta 0:00:00
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
Collecting Jinja2>=3.0
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 26.4 MB/s eta 0:00:00
Collecting Werkzeug>=2.2.2
  Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 30.9 MB/s eta 0:00:00
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.2-cp310-cp310-musllinux_1_1_x86_64.whl (29 kB)
Installing collected packages: MarkupSafe, itsdangerous, click, Werkzeug, Jinja2, Flask
Successfully installed Flask-2.2.3 Jinja2-3.1.2 MarkupSafe-2.1.2 Werkzeug-2.2.3 click-8.1.3 itsdangerous-2.1.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip is available: 23.0 -> 23.0.1
[notice] To update, run: pip install --upgrade pip
Removing intermediate container 119052d7ea82
 ---> c0fd2569ab6a
Step 6/6 : CMD [ "python3", "app.py" ]
 ---> Running in 11cb25ed05eb
Removing intermediate container 11cb25ed05eb
 ---> b86db7fa4bb2
Successfully built b86db7fa4bb2
Successfully tagged manukoli1986/datatonics:v1


```bash
$ docker push manukoli1986/datatonics:v1
The push refers to repository [docker.io/manukoli1986/datatonics]

73b96a21bbf4: Pushed 
b041b3b87fdd: Pushed 
0020a74ffb2b: Pushed 
c539fd0fc10f: Layer already exists 
7cd52847ad77: Layer already exists 

v1: digest: sha256:06be56263973252561d4182d1b98f1ef5397852861168d3907d9e0ca2f2b0d9f size: 1366
```
b. Flasp-app2 & Dockerfile & Build images with version

```
#!/usr/bin/env python3
#Importing module of flask framework to run app on web
from flask import Flask
import datetime


# Create the application.
app = Flask(__name__)


# Displays the index page accessible at '/'
@app.route("/")
def index():
    return ("Hello World !!! - v2")
    


# This code is finish and ready to server on port 80
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)


$ docker build -t manukoli1986/datatonics:v2 .
Sending build context to Docker daemon   12.8kB
Step 1/6 : FROM frolvlad/alpine-python3
latest: Pulling from frolvlad/alpine-python3
63b65145d645: Pull complete 
7ea42724e07f: Pull complete 
Digest: sha256:bb012c6df862247ca8f9438bd031d40e5fb3043669fb7e704b0d65d5f71e84ac
Status: Downloaded newer image for frolvlad/alpine-python3:latest
 ---> def6a48ceb7b
Step 2/6 : EXPOSE 80
 ---> Running in 3dd4a072b944
Removing intermediate container 3dd4a072b944
 ---> 539317d2cc5b
Step 3/6 : WORKDIR /usr/src/app
 ---> Running in 974fa05d6abf
Removing intermediate container 974fa05d6abf
 ---> a5797c1705f8
Step 4/6 : COPY . ./
 ---> 0640928c6e5a
Step 5/6 : RUN pip3 install --no-cache-dir -r requirements.txt
 ---> Running in 119052d7ea82
Collecting Flask
  Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 2.4 MB/s eta 0:00:00
Collecting click>=8.0
  Downloading click-8.1.3-py3-none-any.whl (96 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 10.3 MB/s eta 0:00:00
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
Collecting Jinja2>=3.0
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 26.4 MB/s eta 0:00:00
Collecting Werkzeug>=2.2.2
  Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 30.9 MB/s eta 0:00:00
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.2-cp310-cp310-musllinux_1_1_x86_64.whl (29 kB)
Installing collected packages: MarkupSafe, itsdangerous, click, Werkzeug, Jinja2, Flask
Successfully installed Flask-2.2.3 Jinja2-3.1.2 MarkupSafe-2.1.2 Werkzeug-2.2.3 click-8.1.3 itsdangerous-2.1.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip is available: 23.0 -> 23.0.1
[notice] To update, run: pip install --upgrade pip
Removing intermediate container 119052d7ea82
 ---> c0fd2569ab6a
Step 6/6 : CMD [ "python3", "app.py" ]
 ---> Running in 11cb25ed05eb
Removing intermediate container 11cb25ed05eb
 ---> b86db7fa4bb2
Successfully built b86db7fa4bb2
Successfully tagged manukoli1986/datatonics:v2


$ docker push manukoli1986/datatonics:v2
The push refers to repository [docker.io/manukoli1986/datatonics]

73b96a21bbf4: Pushed 
b041b3b87fdd: Pushed 
0020a74ffb2b: Pushed 
c539fd0fc10f: Layer already exists 
7cd52847ad77: Layer already exists 

v1: digest: sha256:06be56263973252561d4182d1b98f1ef5397852861168d3907d9e0ca2f2b0d9f size: 1366
```

#### Task 2

Now use the k8-manifests file to deploy as docker images are already built in previous steps. 
```bash
$ cd k8-manifests
$ kubectl apply -f deployment1.yaml -f deployment-service.yaml

#Check deployment and svc

$ kubectl get deploy,svc -o wide 

# Now try to access the app thru curl command
$ curl -s http://13.232.174.92:30454/ | grep "Hello" 
Hello World !!! - v1


# Now let run while loop and see the cananry deployment changes
$ kubectl apply -f deployment2.yaml

# From service Find and remove the line version: “1.0”. The file should include the following:

% while true; do curl -s http://13.232.174.92:30454/ | grep "Hello";   sleep 1; done
Hello World !!! - v1
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
̂Hello World !!! - v2
Hello World !!! - v2
Hello World !!! - v2
Hello World !!! - v1
Hello World !!! - v2
Hello World !!! - v2
Hello World !!! - v2

```
#### Monitor the Canary Behavior
With both deployments up and running, monitor the behavior of the new deployment. Depending on the results, you can roll back the deployment or upgrade to the newer version.




# Issue 

1. Used Livness and Readiness probes to solve my problem as when I was using kubectl blue/green deployment it was working fine as I just had to update service object to route the traffic. But using helm it will not wait for new version release and release traffic to it even though it is not active yet. So by using Livness and Readiness new version will only accept traffic once app is completely deployed and up.
2. Duing build flask app, I found rendering template was easy option to show image with text.


Prepared By: Mayank Koli
Kindly update me if there is any issue during deployment.  
