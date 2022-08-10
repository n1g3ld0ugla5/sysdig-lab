read -p "Create the new workloads"
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
read -p "Check to see if the pods are running"
kubectl get pods -w
read -p "Bash exec into the pod"
kubectl exec -i -t $(kubectl get pod -l "app=emailservice" -o jsonpath='{.items[0].metadata.name}') -- bash
read -p "Lets get out of this pod"
exit
read -p "Automatically generates the Terminal shell in container activity"
kubectl exec -i -t $(kubectl get pod -l "app=emailservice" -o jsonpath='{.items[0].metadata.name}') -- /bin/sh
echo "We successfully shelled in to the email pod"
#10 seconds to observe terminal shell activity
read -p "Press enter to continue"
#Each row in /proc/$PID/maps describes a region of contiguous virtual memory in a process or thread.
cat /proc/1/maps
echo "Each row in /proc/$PID/maps describes a region of contiguous virtual memory in a process or thread."
#10 more seconds before exiting the pod
read -p "Press enter to continue"
exit
