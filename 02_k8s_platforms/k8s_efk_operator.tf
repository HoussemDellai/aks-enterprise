# # https://github.com/framsouza/eck-terraform/blob/main/main.tf
# # Install ECK operator via helm-charts
# resource "helm_release" "elastic" {
#   name = "elastic-operator"

#   repository       = "https://helm.elastic.co"
#   chart            = "eck-operator"
#   namespace        = "elastic-system"
#   create_namespace = "true"

#   depends_on = [google_container_cluster._, google_container_node_pool.node-pool, kubernetes_cluster_role_binding.cluster-admin-binding]

# }

# # Delay of 30s to wait until ECK operator is up and running
# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [helm_release.elastic]

#   create_duration = "30s"
# }

# # Create Elasticsearch manifest
# resource "kubectl_manifest" "elastic_quickstart" {
#     yaml_body = <<YAML
# apiVersion: elasticsearch.k8s.elastic.co/v1
# kind: Elasticsearch
# metadata:
#   name: quickstart
# spec:
#   version: 8.1.3
#   nodeSets:
#   - name: default
#     count: 3
#     config:
#       node.store.allow_mmap: false
# YAML

#   provisioner "local-exec" {
#      command = "sleep 60"
#   }
#   depends_on = [helm_release.elastic, time_sleep.wait_30_seconds]
# }
