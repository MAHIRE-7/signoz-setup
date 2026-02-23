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
kubectl create namespace dev-signoz
helm install my-release signoz/k8s-infra -f override-values.yaml 
---

# Upgrade ports
---
helm upgrade dev-signoz signoz/k8s-infra \
  --set otlp.containerPort=1972 \
  --set otlp.servicePort=1972 \
  --set otlp.hostPort=1972 \
  --set otlp-http.containerPort=1973 \
  --set otlp-http.servicePort=1973 \
  --set otlp-http.hostPort=1973 
 
---
# to upgrade
---
helm upgrade my-release signoz/k8s-infra  -f override-values.yaml --reuse-values
 
kubectl delete pod -l app.kubernetes.io/name=otel-collector-agent
---
## Step 3 — Verify ConfigMap Actually Updated
---
kubectl get cm  | grep otel
kubectl describe cm <configmap-name> 
---
# agent rollout / restart
---
kubectl rollout restart daemonset my-release-k8s-infra-otel-agent  
---


=============================================================================
### changes to be done on manifest files
## add below env in deployments, statefulsets
---
env:
  - name: HOST_IP
    valueFrom:
      fieldRef:
        fieldPath: status.hostIP
  - name: K8S_POD_IP
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: status.podIP
  - name: K8S_POD_UID
    valueFrom:
      fieldRef:
        fieldPath: metadata.uid
  - name: OTEL_EXPORTER_OTLP_INSECURE
    value: "true"
  - name: OTEL_EXPORTER_OTLP_ENDPOINT
    value: <Monitoring-vm-ip>:4317
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: service.name=APPLICATION_NAME,k8s.pod.ip=$(K8S_POD_IP),k8s.pod.uid=$(K8S_POD_UID)

---


### !!! for information 
Resource Requirements
Recommended resource allocations based on preset combinations:

Configuration	CPU Request	Memory Request	CPU Limit	Memory Limit
Minimal	            100m	256Mi	            200m	512Mi
Standard	        200m	512Mi	            500m	1Gi
Full	            500m	1Gi	                1000m	2Gi