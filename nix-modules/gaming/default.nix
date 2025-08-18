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
