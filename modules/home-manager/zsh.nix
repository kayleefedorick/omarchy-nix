{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons=auto";
      la = "eza -la --icons=auto";
      cat = "zsh-bat";
      update = "cd /etc/nixos && sudo nix flake update omarchy-nix && sudo nixos-rebuild switch";
    };

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "fdellwing/zsh-bat";
          tags = [ "as:command" ];
        }
      ];
    };
  };
}
