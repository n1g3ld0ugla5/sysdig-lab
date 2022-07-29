# sysdig-lab
Lab Content for testing Sysdig Secure &amp; Falco

``` docker run -d -p 80:80 mcr.microsoft.com/azuredocs/aci-helloworld:latest ```

``` docker ps ```

``` wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/instruqt-mount.yaml ```

``` helm upgrade falco falcosecurity/falco -n falco --reuse-values -f instruqt-mount.yaml ```

``` kubectl get pods -n falco ```

``` kubectl logs --selector app.kubernetes.io/name=falco -n falco | grep sudo ```

14:47:49.958251300: Warning Unauthorized process (sudo ls) running k8s.ns=<NA> k8s.pod=<NA> container=host <br/>
14:47:49.965807188: Warning Unauthorized process (sudo ls) running k8s.ns=<NA> k8s.pod=<NA> container=host
