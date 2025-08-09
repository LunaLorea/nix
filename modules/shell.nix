{
  colors,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neofetch
  ];

  programs = {
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Macchiato";
      settings = {
        background_opacity = "0.8";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch --flake /home/luna/.config/nix#laptop";
        update = "nix flake update --flake /home/luna/.config/nix#laptop";
        tree = "eza --tree --level=5";
      };
      history.size = 10000;

      oh-my-zsh = { 
        enable = true;
        plugins = [ "git" "fzf" "git" ];
        theme = "robbyrussell";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      
    };


    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
