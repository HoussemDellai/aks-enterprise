helm repo update

# PROMETHEUS & GRAFANA
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace `
       --set grafana.adminUser="grafana" --set grafana.adminPassword="@Aa123456789"
start powershell {kubectl port-forward service/prom-grafana 8000:80 -n monitoring}
start microsoft-edge:http://localhost:8000
# Access dashboard: http://localhost:8000
# login: grafana, password: @Aa123456789

# # KASTEN
# start powershell {kubectl port-forward service/gateway 8001:8000 --namespace kasten-io}
# start microsoft-edge:http://localhost:8001/k10/#/
# # Access dashboard: http://localhost:8001/k10/#/

# ARGOCD
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo argo/argo-cd --namespace gitops --create-namespace
start powershell {kubectl port-forward service/argo-argocd-server 8002:80 -n gitops}
start microsoft-edge:http://localhost:8002
# pip3 install bcrypt
# python3 -c "import bcrypt; print(bcrypt.hashpw(b'@Aa123456789', bcrypt.gensalt()).decode())"
# $2b$12$DsmD/P54.U4qMhf9dZbAp.dtPQMumJ7b5VCz36nwSR1k2FUpux4Sm
# Access dashboard: http://localhost:8002
# login: admin, password: @Aa123456789

# ARGO ROLLOUT
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-rollouts argo/argo-rollouts -n argo-rollouts --create-namespace --set dashboard.enabled=true
kubectl port-forward service/argo-rollouts-dashboard 3100:3100 -n argo-rollouts

# KUBECOST
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm upgrade --install kubecost kubecost/cost-analyzer --namespace kubecost --create-namespace --set kubecostToken="aG91c3NlbS5kZWxsYWlAbGl2ZS5jb20=xm343yadf98"
start powershell {kubectl port-forward service/kubecost-cost-analyzer 9090:9090 -n finops}
start microsoft-edge:http://localhost:9090
# Access dashboard: http://localhost:9090

# CERT MANAGER
helm repo add jetstack https://charts.jetstack.io
helm upgrade --install cert-manager --namespace cert-manager --wait jetstack/cert-manager --create-namespace

# HARBOR
# helm repo add harbor https://helm.goharbor.io
# helm install harbor harbor/harbor

# HARBOR OPERATOR (ALL IN ONE)
kubectl apply -f https://raw.githubusercontent.com/goharbor/harbor-operator/master/manifests/cluster/deployment.yaml

# EFK/ECK
# https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html
helm repo add elastic https://helm.elastic.co
kubectl apply -f .\eck-license-secret.yaml
helm upgrade --install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
helm show values elastic/eck-operator
# Install ECK instance
helm install eck-stack -n eck elastic/eck-stack --create-namespace

# LOKI
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install loki --namespace=loki grafana/loki-distributed --create-namespace
helm upgrade --install loki-grafana grafana/grafana -n loki
helm upgrade --install promtail grafana/promtail --set "config.clients[0].url=http://loki-loki-distributed-gateway/loki/api/v1/push" -n loki

# ELK
helm repo add elastic https://helm.elastic.co
helm upgrade --install elasticsearch elastic/elasticsearch -n elk --create-namespace
helm test elasticsearch -n elk
kubectl port-forward svc/elasticsearch-master 9200 -n elk
helm upgrade --install filebeat elastic/filebeat -n elk
helm upgrade --install metricbeat elastic/metricbeat -n elk
helm upgrade --install apm-server elastic/apm-server -n elk
helm upgrade --install kibana elastic/kibana -n elk
kubectl port-forward svc/kibana-kibana 5601 -n elk
# sample Kibana dashboards here:
# https://elastic-content-share.eu/downloads/filebeat-log-analysis-canvas-example/
# https://elastic-content-share.eu/downloads/category/kibana/kibana-visualizations/

# PORTAINER
helm repo add portainer https://portainer.github.io/k8s/
helm upgrade --install -n portainer portainer portainer/portainer --set tls.force=true --create-namespace 

start powershell {kubectl port-forward svc/portainer 9443 -n portainer}
start microsoft-edge:https://localhost:9443
# https://localhost:9443/