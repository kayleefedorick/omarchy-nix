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
      update = "cd /etc/nixos && sudo nix flake update omarchy-nix && sudo nixos-rebuild switch";
    };

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
    oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
	        "git"
        ];
    };
  };
}
