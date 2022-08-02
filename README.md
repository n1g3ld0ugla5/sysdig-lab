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
