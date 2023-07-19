{
  description = "Ghaf - Documentation and implementation for TII SSRC Secure Technologies Ghaf Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixos-generators,
  }: let
    systems = with flake-utils.lib.system; [
      x86_64-linux
      aarch64-linux
    ];
  in
    # Combine list of attribute sets together
    nixpkgs.lib.foldr nixpkgs.lib.recursiveUpdate {} [
      (flake-utils.lib.eachSystem systems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;
        nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (_: {
              system.stateVersion = "23.05";
            })
            ./configuration.nix
          ];
        };
        packages = let
          nixosConfiguration = self.nixosConfigurations.${system}.minimal;
          isoConfiguration = nixosConfiguration.extendModules {
            modules = [
              nixos-generators.nixosModules.iso
            ];
          };
          vmConfiguration = nixosConfiguration.extendModules {
            modules = [
              nixos-generators.nixosModules.vm
            ];
          };
        in {
          iso = isoConfiguration.config.system.build.${isoConfiguration.config.formatAttr};
          vm = vmConfiguration.config.system.build.${vmConfiguration.config.formatAttr};
        };
      }))
    ];
}
