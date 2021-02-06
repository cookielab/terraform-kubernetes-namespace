locals {
  prefix = "${var.cluster_id}-${var.name}"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.name
  }
}

resource "kubernetes_cluster_role" "deploy" {
  metadata {
    name = "${local.prefix}-deploy"
  }

  rule {
    api_groups = ["*"]
    resources = ["nodes"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_role" "deploy" {
  metadata {
    name = "${local.prefix}-deploy"
    namespace = kubernetes_namespace.this.metadata.0.name
  }

  rule {
    api_groups = ["*"]
    resources = ["*"]
    verbs = ["*"]
  }
}

resource "kubernetes_service_account" "deploy" {
  metadata {
    name = "${local.prefix}-deploy-user"
    namespace = kubernetes_namespace.this.metadata.0.name
  }

  automount_service_account_token = false
}

resource "kubernetes_cluster_role_binding" "deploy" {
  metadata {
    name = "${local.prefix}-deploy-user"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.deploy.metadata.0.name
  }

  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = kubernetes_service_account.deploy.metadata.0.name
    namespace = kubernetes_service_account.deploy.metadata.0.namespace
  }
}

resource "kubernetes_role_binding" "deploy" {
  metadata {
    name = "${local.prefix}-deploy-user"
    namespace = kubernetes_namespace.this.metadata.0.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role.deploy.metadata.0.name
  }

  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = kubernetes_service_account.deploy.metadata.0.name
    namespace = kubernetes_service_account.deploy.metadata.0.namespace
  }
}

data "kubernetes_secret" "deploy" {
  metadata {
    name = kubernetes_service_account.deploy.default_secret_name
    namespace = kubernetes_service_account.deploy.metadata.0.namespace
  }
}
