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
  cilium_gateway_api_proxy_protocol_enabled = false
  hcloud_ccm_enabled                        = true
  hcloud_ccm_load_balancers_enabled         = false

  control_plane_nodepools = [
    { name = "control", type = "cx23", location = "fsn1", count = 1 }
  ]

  worker_nodepools = [
    { name = "worker", type = "cx23", location = "fsn1", count = 1 }
  ]

  cilium_helm_values = {
    defaultLBServiceIPAM = "nodeipam"
    nodeIPAM = {
      enabled = true
    }
  }

  firewall_extra_rules = [
    {
      description = "Allow HTTP"
      direction   = "in"
      source_ips  = ["0.0.0.0/0", "::/0"]
      protocol    = "tcp"
      port        = "80"
    },

    {
      description = "Allow HTTPS"
      direction   = "in"
      source_ips  = ["0.0.0.0/0", "::/0"]
      protocol    = "tcp"
      port        = "443"
    }
  ]
}
