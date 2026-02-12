# X-Moto Infra

## Dependencies

### Terraform

- [Packer](https://developer.hashicorp.com/packer)
- [talosctl](https://docs.siderolabs.com/talos/latest/getting-started/talosctl)
- [Terraform](https://developer.hashicorp.com/terraform/install) or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Hetzner Cloud CLI](https://github.com/hetznercloud/cli)

### Kubernetes

- [kubectl](https://kubernetes.io/docs/tasks/tools)
- [age](https://github.com/FiloSottile/age)
- [SOPS](https://github.com/getsops/sops)
- [KSOPS](https://github.com/viaduct-ai/kustomize-sops) (Kustomize SOPS plugin)
- [Helm](https://helm.sh/docs/intro/install)
- [helm-diff](https://github.com/databus23/helm-diff) (Helm plugin, needed by Helmfile)
- [Helmfile](https://github.com/helmfile/helmfile)

## Setup

### Terraform

```bash
cd terraform

# Decrypt config files
sops decrypt kubeconfig.sops.yaml >kubeconfig.yaml
sops decrypt talosconfig.sops.yaml >talosconfig.yaml

# Modify the terraform.tfvars file as needed
cp -i terraform.tfvars.example terraform.tfvars

# Initialize modules and stuff
terraform init

# Preview the changes
terraform plan

# Apply
terraform apply
```

If Terraform makes changes to the `kubeconfig.yaml` or `talosconfig.yaml` files, remember to re-encrypt them into `kubeconfig.sops.yaml` and `talosconfig.sops.yaml` respectively.

### Kubernetes

```bash
cd kubernetes

export KUBECONFIG="$(readlink -f ../terraform)/kubeconfig.yaml"
export SOPS_AGE_KEY_FILE=/path/to/sops/age/k8s.agekey

# This is very common in the Kubernetes world :)
alias k='kubectl'

# You may also want to set a convenience alias for `kustomize build`,
# as these flags are needed by KSOPS.
alias kbuild='kustomize build --enable-alpha-plugins --enable-exec'

# The commands below assume you've set the aliases above.

kbuild bootstrap | k apply -f -
helmfile apply -f helm/helmfile.yaml

kbuild gateway | k apply -f -
kbuild whoami | k apply -f -
```
