{
  pkgs,
  host,
  lib,
  config,
  ...
}: let
  setToChLayout = pkgs.writeShellScriptBin "setToChLayout" "setxkbmap ch";
  setTonotedLayout = pkgs.writeShellScriptBin "setTonotedLayout" "setxkbmap de noted";
in {

  options.modules.gaming = {
    enable = lib.mkEnableOption "steam and other gaming focused applications";
  };

  config = lib.mkIf config.modules.gaming.enable {
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
          setToChLayout
          setTonotedLayout
      ];

      home.file.heroicCatppuccinTheme = {
        enable = true;
        source = pkgs.fetchzip {
          url = "https://github.com/PrismLauncher/Themes/releases/download/2025-06-06_1749223820/Catppuccin-Mocha-theme.zip";
          hash = "sha256-wJCz8NVfxwPpUM+DqeCBrych0DB/9GgDR3psBAE+/pc=";
        };
        target = "./.local/share/PrismLauncher/themes";
      };

      home.file.switchLayoutToCh1 = {
        enable = true;
        source = setToChLayout;
        target = "./.config/switchLayouts/setToChLayout";
      };
      home.file.switchLayoutTonoted1 = {
        enable = true;
        source = setTonotedLayout;
        target = "./.config/switchLayouts/setTonotedLayout";
      };

      wayland.windowManager.sway.extraConfig = ''
        for_window [title="Friends List" class="steam"] move scratchpad; scratchpad show
        for_window [title="Steam Settings" class="steam"] move scratchpad; scratchpad show
        '';
    };
  };
}
