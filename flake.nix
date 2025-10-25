{
  description = "Omarchy - Base configuration flake";
  inputs = {
    base16-schemes.url = "github:kayleefedorick/base16-schemes";
    base16-schemes.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.base16-schemes.follows = "base16-schemes";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      base16-schemes,
      nixpkgs,
      hyprland,
      nix-colors,
      home-manager,
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosModules = {
        default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              (import ./modules/nixos/default.nix inputs)
            ];

            options.omarchy = (import ./config.nix lib).omarchyOptions;
            config = {
              nixpkgs.config.allowUnfree = true;
            };
          };
      };

      homeManagerModules = {
        default =
          {
            config,
            lib,
            pkgs,
            osConfig ? { },
            ...
          }:
          {
            imports = [
              nix-colors.homeManagerModules.default
              (import ./modules/home-manager/default.nix inputs)
            ];
            options.omarchy = (import ./config.nix lib).omarchyOptions;
            config = lib.mkIf (osConfig ? omarchy) {
              omarchy = osConfig.omarchy;
            };
          };
      };
    };
}
