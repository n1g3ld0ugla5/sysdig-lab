curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
chmod +x ./sysdig-cli-scanner
SECURE_API_TOKEN="${SYSDIG_API_TOKEN}" ./sysdig-cli-scanner   gcr.io/tigera-demo/attacker-pod  --apiurl https://eu1.app.sysdig.com
#10 seconds to observe CLI output
sleep 15
#Automatically generates the Terminal shell in container activity
kubectl exec emailservice-d5c6f74dd-s4n5z -n nigel-espionage -it  -- /bin/sh
echo "We successfully shelled in to the email pod"
#10 seconds to observe terminal shell activity
sleep 10
#Each row in /proc/$PID/maps describes a region of contiguous virtual memory in a process or thread.
cat /proc/1/maps
echo "Each row in /proc/$PID/maps describes a region of contiguous virtual memory in a process or thread."
#10 more seconds before exiting the pod
sleep 10
exit
