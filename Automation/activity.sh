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

read -p "Each row in /proc/$PID/maps describes a region of contiguous virtual memory in a process or thread."
read -p "Run (cat /proc/1/maps) for some verbose outputs "
cat /proc/1/maps
read -p "Leave the pod by running (exit) and hit Enter"
exit
