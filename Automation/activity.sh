read -p "Download the latest version of the CLI scanner"
curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
read -p "Turn the file into an executable - (chmod +x ./sysdig-cli-scanner)"
chmod +x ./sysdig-cli-scanner
read -p "If the API token env variable is present, we can scan this image - (gcr.io/tigera-demo/attacker-pod)"
SECURE_API_TOKEN="${SYSDIG_API_TOKEN}" ./sysdig-cli-scanner   gcr.io/tigera-demo/attacker-pod  --apiurl https://eu1.app.sysdig.com

read -p "Create the new workloads"
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
read -p "Check if pods are running - (kubectl get pods)"
kubectl get pods
read -p "Check the IP of each pod - (kubectl get pods -o wide)"
kubectl get pods -o wide
read -p "Check the label of each pod - (kubectl get pods --show-labels)"
kubectl get pods --show-labels
read -p "Bash into the pod based on label - (kubectl exec -i -t $(kubectl get pod -l "app=emailservice" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh)"
kubectl exec -i -t $(kubectl get pod -l "app=emailservice" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh
read -p "When you are done in this pod, run (exit) and hit enter"
exit
read -p "If you don't need the test app, delete it - (kubectl delete -f)"
kubectl delete -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
read -p "Check to see if the pods are deleting"
kubectl get pods
read -p "If the pods are not removed, feel free to check again"
kubectl get pods
