{
  pkgs,
  host,
  ...
}: let
  setToChLayout = pkgs.writeShellScriptBin "setToChLayout" "setxkbmap ch";
  setToDvorakLayout = pkgs.writeShellScriptBin "setToChLayout" "setxkbmap us dvorak";
in {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
      };
    };
    localNetworkGameTransfers.openFirewall = true;
  };

  home-manager.users.${host.userName} = {...}: {
    home.packages = with pkgs; [
      heroic
      prismlauncher
    ];

    home.file.heroicCatppuccinTheme = {
      enable = true;
      source = pkgs.fetchzip {
        url = "https://github.com/PrismLauncher/Themes/releases/download/2025-06-06_1749223820/Catppuccin-Mocha-theme.zip";
        hash = "sha256-wJCz8NVfxwPpUM+DqeCBrych0DB/9GgDR3psBAE+/pc=";
      };
      target = "./.local/share/PrismLauncher/themes";
    };

    home.file.switchLayoutToCh = {
      enable = true;
      source = setToChLayout;
      target = "./.config/switchLayouts/setToChLayout";
    };
    home.file.switchLayoutToDvorak = {
      enable = true;
      source = setToDvorakLayout;
      target = "./.config/switchLayouts/setToDvorakLayout";
    };

    wayland.windowManager.sway.extraConfig = ''
      for_window [title="Friends List" class="steam"] move scratchpad; scratchpad show
      for_window [title="Steam Settings" class="steam"] move scratchpad; scratchpad show
    '';
  };
}
