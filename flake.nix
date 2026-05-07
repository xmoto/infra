{
  description = "xmoto-infra";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;

          overlays = [
            (final: prev: rec {
              kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
                plugins = with prev.kubernetes-helmPlugins; [
                  helm-diff
                ];
              };
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/xmoto/k8s.agekey"
          '';

          packages = with pkgs; [
            # Common
            age
            sops

            # IaC
            hcloud
            opentofu
            packer
            talosctl

            # Kubernetes
            helmfile-wrapped
            k9s
            kubeconform
            kubectl
            kubectl-cnpg
            kubernetes-helm-wrapped
            kustomize
            kustomize-sops

            # Misc
            argocd
          ];
        };
      }
    );
}
