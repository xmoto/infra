# X-Moto Infra

## Dependencies

- [Packer](https://developer.hashicorp.com/packer)
- [talosctl](https://docs.siderolabs.com/talos/latest/getting-started/talosctl)
- [Terraform](https://developer.hashicorp.com/terraform/install) or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Hetzner Cloud CLI](https://github.com/hetznercloud/cli)

## Terraform

```bash
cd terraform

# Modify the terraform.tfvars file as needed
cp -i terraform.tfvars.example terraform.tfvars

# Initialize modules and stuff
terraform init

# Preview the changes
terraform plan

# Apply
terraform apply
```
