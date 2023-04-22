resource kubernetes_namespace efk {
  provider = kubernetes.aks-module
  metadata {
    name = "elk"
  }
}

# https://github.com/elastic/helm-charts
resource helm_release elastic_search {
  provider   = helm.aks-module
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = kubernetes_namespace.efk.metadata.0.name
}

resource helm_release filebeat {
  provider   = helm.aks-module
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = kubernetes_namespace.efk.metadata.0.name
}

resource helm_release metricbeat {
  provider   = helm.aks-module
  name       = "metricbeat"
  repository = "https://helm.elastic.co"
  chart      = "metricbeat"
  namespace  = kubernetes_namespace.efk.metadata.0.name
}

resource helm_release apm-server {
  provider   = helm.aks-module
  name       = "apm-server"
  repository = "https://helm.elastic.co"
  chart      = "apm-server"
  namespace  = kubernetes_namespace.efk.metadata.0.name
}

resource helm_release kibana {
  provider   = helm.aks-module
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = kubernetes_namespace.efk.metadata.0.name
}