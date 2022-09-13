# PROMETHEUS & GRAFANA
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm install prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
start powershell {kubectl port-forward service/prometheus-stack-grafana 8000:80 -n monitoring}
start microsoft-edge:http://localhost:8000
# Access dashboard: http://localhost:8000
# login: admin, password: @Aa123456789

# KASTEN
start powershell {kubectl port-forward service/gateway 8001:8000 --namespace kasten-io}
start microsoft-edge:http://localhost:8001/k10/#/
# Access dashboard: http://localhost:8001/k10/#/

# ARGOCD
start powershell {kubectl port-forward service/argo-argocd-server 8002:80 -n gitops}
start microsoft-edge:http://localhost:8002
# pip3 install bcrypt
# python3 -c "import bcrypt; print(bcrypt.hashpw(b'@Aa123456789', bcrypt.gensalt()).decode())"
# $2b$12$DsmD/P54.U4qMhf9dZbAp.dtPQMumJ7b5VCz36nwSR1k2FUpux4Sm
# Access dashboard: http://localhost:8002
# login: admin, password: @Aa123456789

# KUBECOST
start powershell {kubectl port-forward service/kubecost-cost-analyzer 9090:9090 -n finops}
start microsoft-edge:http://localhost:9090
# Access dashboard: http://localhost:9090

# CERT MANAGER
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager --namespace cert-manager --wait jetstack/cert-manager --create-namespace

# HARBOR
# helm repo add harbor https://helm.goharbor.io
# helm install harbor harbor/harbor

# HARBOR OPERATOR (ALL IN ONE)
kubectl apply -f https://raw.githubusercontent.com/goharbor/harbor-operator/master/manifests/cluster/deployment.yaml

# EFK/ECK
# https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html
helm repo add elastic https://helm.elastic.co
kubectl apply -f .\eck-license-secret.yaml
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
helm show values elastic/eck-operator
# Install ECK instance
helm install eck-stack -n eck elastic/eck-stack --create-namespace

# LOKI
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install loki --namespace=loki grafana/loki-distributed --create-namespace
helm install loki-grafana grafana/grafana -n loki
helm upgrade --install promtail grafana/promtail --set "config.clients[0].url=http://loki-loki-distributed-gateway/loki/api/v1/push" -n loki

# EFK
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch -n efk --create-namespace
helm test elasticsearch -n efk
kubectl port-forward svc/elasticsearch-master 9200 -n efk
helm install filebeat elastic/filebeat -n efk
helm install metricbeat elastic/metricbeat -n efk
helm install apm-server elastic/apm-server -n efk
helm install kibana elastic/kibana -n efk
kubectl port-forward svc/kibana-kibana 5601 -n efk
# sample Kibana dashboards here:
# https://elastic-content-share.eu/downloads/filebeat-log-analysis-canvas-example/
# https://elastic-content-share.eu/downloads/category/kibana/kibana-visualizations/