#    .---------- constant part!
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Colorea
read -p $'\e[31mPassword Required\e[0m: ' Will add a password soon
read -p "Now that you're connected to Sysdig Secure, we can download the latest version of the CLI Scanner"
curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
read -p "Turn the file into an executable - (chmod +x ./sysdig-cli-scanner)"
chmod +x ./sysdig-cli-scanner
read -p "If the API token env variable is present, we can scan this image - (gcr.io/tigera-demo/attacker-pod)"
SECURE_API_TOKEN="773a8ca9-343c-4004-8043-6323ce8c2044" ./sysdig-cli-scanner   gcr.io/tigera-demo/attacker-pod  --apiurl https://eu1.app.sysdig.com

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
read -p "Now that you are out of the exec session, lets check the web UI for the critical activity"
read -p "If you don't need the test app, delete it - (kubectl delete -f)"
kubectl delete -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
read -p "Check to see if the pods are deleting"
kubectl get pods
read -p "All other pods should remain in the cluster"
kubectl get pods -A

read -p "Create a ServiceAccount in the kube-system namespace"
kubectl create sa nigel -n kube-system
read -p "Creating or Deleting a ServiceAccount in kube-system triggers activity"
kubectl get sa -n kube-system | grep nigel
read -p "Delete the newly-create ServiceAccount and check the web user interface"
kubectl delete sa nigel -n kube-system
read -p "Let's find the core-dns pods running in the kube-system namespace"
kubectl get pods -n kube-system --show-labels
read -p "Delete the core-dns pods - (kubectl delete pod -l k8s-app=kube-dns -o jsonpath='{.items[0].metadata.name}')"
kubectl delete pod -l "k8s-app=kube-dns" -n kube-system
read -p "Confirm the kube-system pods are recreating pod"
kubectl get pods -n kube-system
read -p "Again, check the Sysdig Secure user interface for changes"

# Create the local directory
read -p "Create a local directory for configmaps"
mkdir -p configure-pod-container/configmap/

# Download the sample files into `configure-pod-container/configmap/` directory
read -p "Download 2 sample files into that new directory"
wget https://kubernetes.io/examples/configmap/game.properties -O configure-pod-container/configmap/game.properties
wget https://kubernetes.io/examples/configmap/ui.properties -O configure-pod-container/configmap/ui.properties

# Create the configmap from the above files
read -p "Create namespace for ConfigMap"
kubectl create ns nigel-test-namespace
read -p "Create ConfigMap in that new namespace"
kubectl create configmap game-config --from-file=configure-pod-container/configmap/ -n nigel-test-namespace

read -p "Confirm the ConfigMap was created"
kubectl get cm -A | grep nigel

read -p "Remove some sensitive data from the ConfigMap"
kubectl edit cm game-config -n nigel-test-namespace

# Cleanup
read -p "As always, check the web user interface for updates"
rm -r configure-pod-container/configmap/
cd
kubectl delete cm game-config -n nigel-test-namespace
kubectl delete ns nigel-test-namespace
kubectl get pods -A

read -p "That's the end of my tutortial for now. lol"
clear
