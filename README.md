# Falco Lab Scenario

This YAML file outlined the following items as forbidden_processes - [mount, sudo, su]

``` wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/instruqt-mount.yaml ```

Update the falco ruleset

``` helm upgrade falco falcosecurity/falco -n falco --reuse-values -f instruqt-mount.yaml ```

Make sure pods are recreated after the falco rules update

``` kubectl get pods -n falco ```

list the files as a priveleged user

``` sudo ls ``` 

The log output of the pod should now show that this was an unauthorized process:

``` kubectl logs --selector app.kubernetes.io/name=falco -n falco | grep sudo ```

14:47:49.958251300: Warning Unauthorized process (sudo ls) running k8s.ns=<NA> k8s.pod=<NA> container=host <br/>
14:47:49.965807188: Warning Unauthorized process (sudo ls) running k8s.ns=<NA> k8s.pod=<NA> container=host

``` wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/required_engine_version.yaml ```

Execute the following command to re-run Falco with the required engine version of 99:

``` helm upgrade falco falcosecurity/falco -n falco --reuse-values -f required_engine_version.yaml ```

Basically, it'll note that the engine version should be '9' - not '99':

``` kubectl logs --selector app.kubernetes.io/name=falco -n falco ```

