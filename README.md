# Kaylee's Omarchy Nix Config
A modern, opinionated **NixOS + Hyprland** configuration, forked from [henrysipp/omarchy-nix](https://github.com/henrysipp/omarchy-nix).
This fork builds on the original project with **new themes, packages, UI tweaks, browser changes, and shell improvements** for a smooth and personal workflow.

## ✨ Overview

**Omarchy Nix (Omanix?)** is an opinionated NixOS flake to help you get started fast with **NixOS** and **Hyprland**.
It reimplements [DHH’s Omarchy](https://github.com/dhh/omarchy) (an Arch-based setup for modern web development) in NixOS.

Kaylee’s fork adds:

* 🌈 Refined **Waybar styling**, colors, and clock design
* 🖼️ Custom **wallpapers and themes** (default BugOS theme - based on Dracula)
* 💻 **Zen Browser** set as the default (with custom policies and Firefox extensions)
* 🧩 Preinstalled **Bitwarden**, **TransparentZen**, and other browser tools
* 🐚 Enhanced **Zsh configuration**, plugins, and prompt customization
* 🧰 Curated package list (Micro, Nemo, Kitty, Celluloid, and more)
* 🔋 Added **power-profiles-daemon** and natural scrolling
* ⚙️ Simplified **OS update workflow** via an `update` and `update-all` aliases
* 🎨 GTK and terminal font tweaks, better scaling, and consistent dark theme defaults


## 🚀 Quick Start

1. **Install NixOS**
   Get a fresh install of NixOS — any recent ISO (25.05+ recommended).

2. **Add this flake** to your configuration:

```nix
{
	description = "omarchy-nix flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs";
		omarchy-nix = {
			url = "github:kayleefedorick/omarchy-nix";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, omarchy-nix, home-manager }@inputs: {
		nixosConfigurations.nixos= nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				omarchy-nix.nixosModules.default
				home-manager.nixosModules.home-manager
				{
					omarchy = {
						full_name = "Your Name Here";
						email_address = "youremail@address.com";
						theme = "bugos";
						scale = 1; # set to 2 for hidpi displays
						#theme_overrides = {
						#  wallpaper_path = ./default.png;
						#};
						
					};
					home-manager = {
						users.yourusername = {
							imports = [ omarchy-nix.homeManagerModules.default ];
						};
                        useGlobalPkgs = true;
					};
				}
			];
		};
	};
}
```

2. **Modify your base configuration** as needed. Here is an example `configuration.nix`:
```nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Shell
  programs.zsh.enable = true;

  # Define user account
  # Don't forget to set a password with ‘passwd’
  users.users.yourusername = {
    isNormalUser = true;
    description = "Your User Name";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Setup Home Manager for user account
  home-manager.users.yourusername = { pkgs, ... }: {
  	home.packages = [ pkgs.atool pkgs.httpie ];
  	programs.bash.enable = true;
  	home.stateVersion = "25.05";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
     micro
     git
     wget
  ];

  # Default editor
  environment.variables.EDITOR = "micro";

  system.stateVersion = "25.05";

}
```

## Configuration Options

Basic customization is exposed through the `omarchy` module:

* `full_name` – your full name for Git and app configs
* `email_address` – email for Git commits
* `theme` – global color scheme (see list below)
* `theme_overrides.wallpaper_path` – custom wallpaper

You can tweak font, scaling, terminal, GTK theme, browser policies, and more through your home-manager layer.

### Themes

Omarchy-nix includes several predefined themes:
- `bugos` (default) *(new)* - based on Dracula
- `tokyo-night`
- `kanagawa`
- `everforest`
- `catppuccin`
- `nord`
- `gruvbox`
- `gruvbox-light`

You can also generate themes from wallpaper images using:
- `generated_light` - generates a light color scheme from wallpaper
- `generated_dark` - generates a dark color scheme from wallpaper

Generated themes require a wallpaper path to be specified:

```nix
{
  omarchy = {
    theme = "generated_dark"; # or "generated_light"
    theme_overrides = {
      wallpaper_path = ./path/to/your/wallpaper.png;
    };
  };
}
```

#### Wallpaper Overrides

Any theme can be customized with a custom wallpaper by specifying `wallpaper_path` in theme_overrides. For predefined themes, this will only change the wallpaper but keep the original color scheme:

```nix
{
  omarchy = {
    theme = "tokyo-night"; # or any other predefined theme
    theme_overrides = {
      wallpaper_path = ./path/to/your/wallpaper.png;
    };
  };
}
```

Generated themes automatically extract colors from the wallpaper and create a matching color scheme for all Omarchy applications (terminal, editor, launcher, etc.). 

## Updating

Aliases are provided to make updating omarchy-nix easier.

* `update-all` alias – update all flake inputs, push new inputs to repo (point to your own repo as needed), and rebuild system in one command
* `update` alias - update omarchy-nix flake only and rebuild system

## License

This project is released under the MIT License, same as the original Omarchy.
