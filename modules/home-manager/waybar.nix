inputs:
{
  config,
  pkgs,
  ...
}:
let
  palette = config.colorScheme.palette;
  convert = inputs.nix-colors.lib.conversions.hexToRGBString;
  backgroundRgb = "rgb(${convert ", " palette.base00})";
  foregroundRgb = "rgb(${convert ", " palette.base05})";
  accent1Rgb = "rgb(${convert ", " palette.base08})";     # pink
  accent2Rgb = "rgb(${convert ", " palette.base0B})";     # yellow
  accent3Rgb = "rgb(${convert ", " palette.base03})";     # periwinkle
  accent4Rgb = "rgb(${convert ", " palette.base09})";     # purple
in
{
  home.file = {
    ".config/waybar/" = {
      source = ../../config/waybar;
      recursive = true;
    };
    ".config/waybar/theme.css" = {
      text = ''
        @define-color background ${backgroundRgb};
        @define-color foreground ${foregroundRgb};
        @define-color accent1 ${accent1Rgb};
        @define-color accent2 ${accent2Rgb};
        @define-color accent3 ${accent3Rgb};
        @define-color accent4 ${accent4Rgb};

        * {
          color: @accent2; 
        }
        window#waybar {
          background-color: @background;
        }
        #window * {
          color: @accent2;
        }
        #clock {
          color: @accent4;
        }
        #workspaces * {
          color: @accent3;
        }
        #tray,
        #bluetooth,
        #network,
        #wireplumber,
        #cpu,
        #power-profiles-daemon,
        #battery {
          color: @accent3;
        }
      '';
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          # "custom/dropbox"
          "tray"
          "bluetooth"
          "network"
          "wireplumber"
          "cpu"
          "power-profiles-daemon"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󱓻";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "ghostty -e btop";
        };
        clock = {
          format = " Buggy {:%A %I:%M %p}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };
        network = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = "ghostty -e nmcli";
        };
        battery = {
          interval = 5;
          format = "{capacity}% {icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          states = {
            warning = 20;
            critical = 10;
          };
        };
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueberry";
        };
        wireplumber = {
          # Changed from "pulseaudio"
          "format" = "";
          format-muted = "󰝟";
          scroll-step = 5;
          on-click = "pavucontrol";
          tooltip-format = "Playing at {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Updated command
          max-volume = 150; # Optional: allow volume over 100%
        };
        tray = {
          spacing = 13;
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            power-saver = "󰡳";
            balanced = "󰊚";
            performance = "󰡴";
          };
        };
        # "custom/dropbox" = {
        #   format = "";
        #   on-click = "nautilus ~/Dropbox";
        #   exec = "dropbox-cli status";
        #   return-type = "text";
        #   interval = 5;
        #   tooltip = true;
        #   tooltip-format = "{}";
        # };
      }
    ];
  };
}
