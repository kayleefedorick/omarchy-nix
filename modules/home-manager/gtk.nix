{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Adwaita";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Adwaita Sans 11";
      font-rgba-order = "rgb";
      gtk-theme = "dracula-theme";
      icon-theme = "Adwaita";
      text-scaling-factor = 1.0;
      toolbar-icons-size = "large";
      toolbar-style = "both-horiz";
    };
  };
}
