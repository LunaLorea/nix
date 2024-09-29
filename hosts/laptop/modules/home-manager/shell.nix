{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      themeFile = "Afterglow";
      settings = {
        background_opacity = "0.8";
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
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
