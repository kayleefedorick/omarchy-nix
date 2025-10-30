{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.omarchy;
in
{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
  ];
  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "kitty";
    "$fileManager" = lib.mkDefault "nemo";
    "$browser" = lib.mkDefault "zen";
    "$music" = lib.mkDefault "spotify";
    "$passwordManager" = lib.mkDefault "bitwarden";
    "$webapp" = lib.mkDefault "$browser --app";

    monitor = cfg.monitors;
  };
}
