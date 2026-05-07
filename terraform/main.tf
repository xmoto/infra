variable "hcloud_token" {
  sensitive = true
  default   = ""
}

module "kubernetes" {
  source  = "hcloud-k8s/kubernetes/hcloud"
  version = "4.0.0"

  cluster_name = "k8s"
  hcloud_token = var.hcloud_token

  cluster_kubeconfig_path  = "kubeconfig.yaml"
  cluster_talosconfig_path = "talosconfig.yaml"

  cert_manager_enabled                      = true
  cilium_gateway_api_enabled                = true
  cilium_gateway_api_proxy_protocol_enabled = true
  hcloud_ccm_enabled                        = true

  control_plane_nodepools = [
    { name = "control", type = "cx23", location = "nbg1", count = 1 }
  ]

  worker_nodepools = []
}
