# sysdig-lab
Lab Content for testing Sysdig Secure &amp; Falco

``` docker run -d -p 80:80 mcr.microsoft.com/azuredocs/aci-helloworld:latest ```

``` docker ps ```

``` wget https://raw.githubusercontent.com/n1g3ld0ugla5/sysdig-lab/main/falco-rules/instruqt-mount.yaml ```

``` helm upgrade falco falcosecurity/falco -n falco --reuse-values -f instruqt-mount.yaml ```

``` kubectl get pods -n falco ```
