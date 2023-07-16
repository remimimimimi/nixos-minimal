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
            nixos-generators.nixosModules.iso
            ./configuration.nix
          ];
        };
        packages = let
          cfg = self.nixosConfigurations.${system}.minimal.config;
        in {
          ${cfg.formatAttr} = cfg.system.build.${cfg.formatAttr};
          vm = cfg.system.build.vm;
        };
      }))
    ];
}
