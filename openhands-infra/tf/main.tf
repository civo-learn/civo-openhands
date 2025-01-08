resource "helm_release" "openhands" {
  name             = "openhands"
  create_namespace = true
  namespace        = "openhands"

  chart = "../helm/"

  replace = true
  timeout = 900

depends_on = [ local_file.cluster-config ]

}

data "kubernetes_service" "openhands_service" {
  metadata {
    name      = "openhands-service"
    namespace = "openhands"
  }

  depends_on = [ helm_release.openhands ]
}

output "openhands_lb_ip" {
  description = "External IP for the OpenHands LoadBalancer service"
  value       = try(data.kubernetes_service.openhands_service.status.0.load_balancer.0.ingress.0.ip, "")
}

output "openhands_lb_hostname" {
  description = "External Hostname for the OpenHands LoadBalancer service"
  value       = try(data.kubernetes_service.openhands_service.status.0.load_balancer.0.ingress.0.hostname, "")
}