{
  config,
  pkgs,
  ...
}:
let 
  cfg = config.omarchy;
  palette = config.colorScheme.palette;
in
{
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    font.name = cfg.primary_font;
    font.size = 10;
    enableGitIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.95";
      background_blur = 5;
    };
  };
}
