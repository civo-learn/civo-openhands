# # # # # # # # # # # # # 
# Cluster Configuration # 
# # # # # # # # # # # # # 

# The name of the cluster
variable "cluster_name" {
  type        = string
  default     = "civo-openhands"
  description = "The name of the cluster to create"
}

# the GPU node instance to use for the cluster
variable "cluster_node_size" {
  type = string
  default     = "g4c.kube.medium"
  description = "The size of the node required for the cluster"
}

# the number of nodes to provision in the cluster
variable "cluster_node_count" {
  type        = number
  default     = "2"
  description = "The number of nodes to provision in the cluster"

}

# # # # # # # # # # # 
# Civo configuration # 
# # # # # # # # # # # 

# The Civo API token, this is set in terraform.tfvars
variable "civo_token" {
  type        = string
  description = "The Civo API token"
}

# The Civo Region to deploy the cluster in
variable "region" {
  type        = string
  default     = "LON1"
  description = "The region to provision the cluster against"
}


# # # # # # # # # # # # # # # # # # # # # #
# Openhands Boilerplate deployment flags  # 
# # # # # # # # # # # # # # # # # # # # # # 

# Deploy the openhands Helm chart
