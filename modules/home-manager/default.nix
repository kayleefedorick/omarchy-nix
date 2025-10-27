inputs:
{
  config,
  pkgs,
  lib,
  fonts,
  ...
}:
let
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = config.omarchy.exclude_packages;
  };

  themes = import ../themes.nix;

  # Handle theme selection - either predefined or generated
  selectedTheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      null
    else
      themes.${config.omarchy.theme};

  # Generate color scheme from wallpaper for generated themes
  generatedColorScheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      (inputs.nix-colors.lib.contrib { inherit pkgs; }).colorSchemeFromPicture {
        path = config.omarchy.theme_overrides.wallpaper_path;
        variant = if config.omarchy.theme == "generated_light" then "light" else "dark";
      }
    else
      null;

  # Recursive YAML writer for Nix attrsets
  toYAML = attrs:
    let
      indent = level: lib.concatStrings (lib.replicate level "  ");
      render = level: value:
        if lib.isAttrs value then
          lib.concatStringsSep "\n"
            (lib.mapAttrsToList
              (k: v: "${indent level}${k}: ${if lib.isAttrs v then "\n${render (level + 1) v}" else toString v}")
              value)
        else if lib.isList value then
          lib.concatStringsSep "\n"
            (map (v: "${indent level}- ${toString v}") value)
        else
          toString value;
    in
      render 0 attrs;

in
{
  imports = [
    (import ./hyprland.nix inputs)
    (import ./hyprlock.nix inputs)
    (import ./hyprpaper.nix)
    (import ./hypridle.nix)
    (import ./kitty.nix)
    (import ./micro.nix)
    (import ./btop.nix)
    (import ./direnv.nix)
    (import ./git.nix)
    (import ./mako.nix)
    (import ./starship.nix)
    (import ./vscode.nix)
    (import ./waybar.nix inputs)
    (import ./wofi.nix)
    (import ./zoxide.nix)
    (import ./zsh.nix)
  ];

  home.file = lib.mkMerge [
    {
      ".local/share/omarchy/bin" = {
        source = ../../bin;
        recursive = true;
      };
    }

    # Only write the YAML file if a generated theme is used
    (lib.mkIf (generatedColorScheme != null) {
      "color-scheme.yaml".text = toYAML generatedColorScheme;
    })
  ];

  home.packages = packages.homePackages;

  colorScheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      generatedColorScheme
    else
      inputs.nix-colors.colorSchemes.${selectedTheme.base16-theme};

  gtk = {
    enable = true;
    theme = {
      name = if config.omarchy.theme == "generated_light" then "Adwaita" 
      else if config.omarchy.theme == "bugos" then "Dracula"
      else "Adwaita:dark";
      package = if config.omarchy.theme == "bugos" then pkgs.dracula-theme
      else pkgs.gnome-themes-extra;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      name = if config.omarchy.theme == "bugos" then "candy-icons" else "Adwaita";
      package = if config.omarchy.theme == "bugos" then pkgs.candy-icons else pkgs.gnome-themes-extra;
    };
  };

  home.sessionVariables = {
    GTK_THEME = if config.omarchy.theme == "generated_light" then "Adwaita" 
    else if config.omarchy.theme == "bugos" then "Dracula"
    else "Adwaita:dark";
  };

  xdg.terminal-exec = {
  	enable = true;
  	settings = {
  		default = [
  			"kitty.desktop"
  		];
  	};
  };

  programs.neovim.enable = false;
}
