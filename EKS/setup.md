# To add the SigNoz Helm repository to your helm client, run the following command:
---
helm repo add signoz https://charts.signoz.io
helm repo update
---

# create override-values.yaml already in the dir 
## Replace <CLUSTER_NAME> with the name of the Kubernetes cluster or a unique identifier of the cluster.
## Replace <DEPLOYMENT_ENVIRONMENT> with the deployment environment of your application. Example: "staging", "production", etc.

# To install the k8s-infra chart with the above configuration, run the following command:
---
helm install my-release signoz/k8s-infra -f override-values.yaml
---
# to upgrade
---
helm upgrade my-release signoz/k8s-infra  -f override-values.yaml
---
# agent rollout / restart
---
kubectl rollout restart daemonset my-release-k8s-infra-otel-agent
---


### !!! for information 
Resource Requirements
Recommended resource allocations based on preset combinations:

Configuration	CPU Request	Memory Request	CPU Limit	Memory Limit
Minimal	            100m	256Mi	            200m	512Mi
Standard	        200m	512Mi	            500m	1Gi
Full	            500m	1Gi	                1000m	2Gi