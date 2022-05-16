git clone https://github.com/prometheus-operator/kube-prometheus

cd kube-prometheus

# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl apply --server-side -f manifests/setup

until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl apply -f manifests/

# access Prometheus
kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
# Then access via http://localhost:9090

# access Grafana
kubectl --namespace monitoring port-forward svc/grafana 3000
# Then access via http://localhost:3000 and use the default grafana user:password of admin:admin.

# access Alert Manager
kubectl --namespace monitoring port-forward svc/alertmanager-main 9093
#Then access via http://localhost:9093