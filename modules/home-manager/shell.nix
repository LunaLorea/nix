{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neofetch
  ];

  programs = {
    kitty = {
      enable = true;
      themeFile = "Afterglow";
      settings = {
        background_opacity = "0.92";
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''eval "$(oh-my-posh init bash)"'';
      # initExtra = ''neofetch'';
      shellAliases = {
        tree = "eza --tree --level=5";
      };
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      # useTheme = "M365Princess";
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh-config.json));
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
