variable "cluster_id" {
  type = string
  description = "Cluster id (will be used as resources prefix)"
}

variable "name" {
  type = string
  description = "Namespace name"
}

variable "namespace_labels" {
  type = map(string)
  description = "Labels for namespace"
  default = {}
}
