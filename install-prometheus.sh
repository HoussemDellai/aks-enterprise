mkdir prometheus

cd prometheus

git clone https://github.com/prometheus-operator/kube-prometheus

# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl apply --server-side -f manifests/setup

until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl apply -f manifests/