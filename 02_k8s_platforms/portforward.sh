# PROMETHEUS & GRAFANA
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm install prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
kubectl port-forward service/prometheus-stack-grafana 8008:80 -n monitoring
# Access dashboard: http://localhost:8008
# login: admin, password: @Aa123456789

# KASTEN
kubectl port-forward service/gateway 8000:8000 --namespace kasten-io 
# Access dashboard: http://127.0.0.1:8000/k10/#/

# KUBECOST
kubectl port-forward service/kubecost-cost-analyzer 9090:9090 -n finops
# Access dashboard: http://localhost:9090

# ARGOCD
kubectl port-forward service/argo-argocd-server 8009:80 -n gitops
pip3 install bcrypt
python3 -c "import bcrypt; print(bcrypt.hashpw(b'@Aa123456789', bcrypt.gensalt()).decode())"
# $2b$12$DsmD/P54.U4qMhf9dZbAp.dtPQMumJ7b5VCz36nwSR1k2FUpux4Sm
# Access dashboard: http://localhost:8009
# login: admin, password: @Aa123456789

# HARBOR
# helm repo add harbor https://helm.goharbor.io
# helm install harbor harbor/harbor
