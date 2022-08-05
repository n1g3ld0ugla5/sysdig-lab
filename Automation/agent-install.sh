#!/bin/bash
export SYSDIG_ACCESS_KEY="*****"
export SYSDIG_API_TOKEN="*****"
export SAAS_REGION="eu1"
export COLLECTOR_ENDPOINT="ingest-eu1.app.sysdig.com"
export COLLECTOR_PORT="6443"
export API_ENDPOINT="eu1.app.sysdig.com"
export K8S_CLUSTER_NAME="nigel-eks-cluster2"
export CLUSTER_REGION="eu-west-1"
export NODEGROUP_NAME="${K8S_CLUSTER_NAME}-nodegroup"
export PASSPHRASE="helloworld"
export INSTANCETYPE="m4.xlarge"
export NODES="1"

eksctl create cluster -n ${K8S_CLUSTER_NAME} \
  --nodegroup-name ${NODEGROUP_NAME} \
  --region ${CLUSTER_REGION} \
  --node-type ${INSTANCETYPE} \
  --nodes ${NODES}

echo "${K8S_CLUSTER_NAME} was installed successfully"

helm repo update

helm install sysdig sysdig/sysdig-deploy \
  --namespace sysdig-agent \
  --create-namespace \
  --set global.sysdig.accessKey=${SYSDIG_ACCESS_KEY} \
  --set global.sysdig.region=${SAAS_REGION} \
  --set global.clusterConfig.name=${K8S_CLUSTER_NAME} \
  --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
  --set nodeAnalyzer.nodeAnalyzer.apiEndpoint=${API_ENDPOINT} \
  --set global.kspm.deploy=true \
  --set agent.sysdig.settings.collector=${COLLECTOR_ENDPOINT} \
  --set agent.sysdig.settings.collector_port=${COLLECTOR_PORT} \
  --set agent.sysdig.settings.drift_killer.enabled=true \
  --set agent.slim.enabled=true

echo "Sysdig agent was installed successfully"

helm install rapid-response sysdig/rapid-response \
  --namespace sysdig-rapid-response \
  --create-namespace \
  --set sysdig.accessKey=${SYSDIG_ACCESS_KEY} \
  --set rapidResponse.passphrase=${PASSPHRASE} \
  --set rapidResponse.apiEndpoint=${API_ENDPOINT}

echo "The rapid response passphrase is ${PASSPHRASE}"

helm install sysdig-admission-controller sysdig/admission-controller \
--create-namespace -n sysdig-admission-controller \
--set sysdig.secureAPIToken=${SYSDIG_API_TOKEN} \
--set clusterName=${K8S_CLUSTER_NAME} \
--set sysdig.url=${API_ENDPOINT} \
--set features.k8sAuditDetections=true 

echo "Your admission controller was installed successfully"
