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
