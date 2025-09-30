{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  cfg = config.modules.quickshell;
in {
  options.modules.quickshell = {
    enable = lib.mkEnableOption "quickshell bar";
  };

  config = lib.mkIf config.modules.quickshell.enable {
    environment.defaultPackages = with pkgs; [
      quickshell
    ];

    home-manager.users.${host.userName} = {...}: {
      imports = [
        ./qml-colors.nix
      ];

      home.file.shellqml = {
        enable = true;
        target = "./.config/quickshell/shell.qml";
        source = pkgs.writeTextFile {
          text = builtins.readFile ./shell.qml;
          name = "shell.qml";
        };
      };
    };
  };
}
