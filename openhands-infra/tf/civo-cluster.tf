resource "civo_kubernetes_cluster" "cluster" {
    name = var.cluster_name
    
    # Connect to the network & firewall
    firewall_id = civo_firewall.firewall.id
    network_id  = civo_network.network.id
        
    write_kubeconfig = true
    
    # attach one 
    pools {
        size = var.cluster_node_size
        node_count = var.cluster_node_count
    }
    
    # specify a timeout for the cluster creation
    timeouts {
        create = "10m"
    }
}

# Creating priviledged namespace to allow Dind functionality
resource "null_resource" "wait_for_api" {
  provisioner "local-exec" {
    command = <<EOT
      for i in {1..30}; do
        kubectl --kubeconfig="./kubeconfig" get nodes && break || sleep 10
      done
    EOT
  }
  depends_on = [civo_kubernetes_cluster.cluster]
}

resource "kubectl_manifest" "openhands_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: openhands
  annotations:
    pod-security.kubernetes.io/enforce: privileged
    pod-security.kubernetes.io/audit: privileged
    pod-security.kubernetes.io/warn: privileged
YAML

  depends_on = [null_resource.wait_for_api]
}


# Create a local file with the kubeconfig
resource "local_file" "cluster-config" {
  content              = civo_kubernetes_cluster.cluster.kubeconfig
  filename             = "${path.module}/kubeconfig"
  file_permission      = "0600"
  directory_permission = "0755"
}


# output "kubeconfig" {
#   value = civo_kubernetes_cluster.cluster.kubeconfig
# }