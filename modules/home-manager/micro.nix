{
  config,
  pkgs,
  ...
}:
let
in
{
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "simple";    
      };
  };
}
