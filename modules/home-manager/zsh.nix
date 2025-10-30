{ 
  lib,
  ... 
}:
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
      update-all = "cd ~/git/omarchy-nix && sudo nix flake update omarchy-nix && git add . && git commit -m 'Update inputs' && git push && cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch";
    };

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
    oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
	        "git"
          "copyfile"
          "copypath"
        ];
    };

    initContent = lib.mkAfter ''
      # Show user/host name
      export SHOW_USER=true
      if [[ "$SHOW_USER" == "true" ]]; then
        RPROMPT="%F{white}(%F{magenta}%n%F{white}@%F{cyan}%m%F{white})"
      fi
    '';
  };
}
