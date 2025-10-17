{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  cfg = config.modules.quickshell;
  mkQmlListFromList = list: if list == [] then "" else 
  ''"${lib.strings.concatStringsSep "\",\n          \"" list}"'';

  mkMonitorsList = name: attrs: ''
  {
        "name": "${name}",
        "scale": ${lib.strings.floatToString attrs.scale},
        "showBar": ${lib.boolToString attrs.showBar},
        "barPosition": "${attrs.barPosition}",
        "barWidgets": {
          "left": [
            ${mkQmlListFromList attrs.barWidgets.left}
          ],
          "middle": [
            ${mkQmlListFromList attrs.barWidgets.middle}
          ],
          "right": [
            ${mkQmlListFromList attrs.barWidgets.right}
          ]
        }
      }'';
  settingsText = ''
      pragma Singleton

      import Quickshell
      import QtQuick
      import qs.Commons

      Singleton {
        id: root

        property string shellName: "quickBar"

        // --- bar settings
        property var bar: {
          "backgroundOpacity": ${lib.strings.floatToString cfg.bar.backgroundOpacity},
          "capsule": ${lib.boolToString cfg.bar.capsule},
          "floating": ${lib.boolToString cfg.bar.floating}
        }

        // --- monitors
        property list<var> monitors: [
          ${lib.strings.concatStringsSep ",\n    " (lib.mapAttrsToList mkMonitorsList cfg.monitors)}
        ]


        // --- Clock Settings
        property string clockFormat: "${cfg.bar.clockFormat}"


        signal settingsLoaded

        Component.onCompleted: {
          Logger.log("Settings", "Settings loaded")
          settingsLoaded()
        }
        // --- Persistant Files
        property string cacheDir: Quickshell.env("HOME") + "/.cache" + "/" + shellName + "/"
      }
      '';


in {
  options.modules.quickshell = {
    enable = lib.mkEnableOption "quickshell bar";
    developerMode = {
      enable = lib.mkEnableOption "developer option";
      path = lib.mkOption {
        type = lib.types.path;
        default = "/home/${host.userName}/.config/nix/modules/quickshell/qsConfig";
      };
    };
    monitors = lib.mkOption {
      type = lib.types.attrsOf ( lib.types.submodule ({ ... }: {
        options = {
          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
          };
          showBar = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          barPosition = lib.mkOption {
            type = lib.types.str;
            default = "top";
          };
          barWidgets = {
            left = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "systemMonitor"
                "workspaces"
              ];
            };
            middle = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = ["clock"];
            };
            right = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "pomodoro"
                "wifi"
                "bluetooth"
                "audio"
                "controlCenter"
              ];
            };
          };
        };
      }));
      default = {
        "*" = {};
      };
    };
    bar = {
      backgroundOpacity = lib.mkOption {
        type = lib.types.float;
        default = 0.0;
      };
      clockFormat = lib.mkOption {
        type = lib.types.str;
        default = "HH:mm ddd dd.MM.yy";
      };
      capsule = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      floating = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };  
    };
  };

  config = lib.mkIf config.modules.quickshell.enable {
    environment.defaultPackages = with pkgs; [
      quickshell
      openpomodoro-cli
    ];

    home-manager.users.${host.userName} = {...}: {
      imports = [
        ./qml-colors.nix
        #./placeConfig.nix
      ];

      xdg.configFile.quickshell = {
        enable = true;
        recursive = true;
        source = ./qsConfig;
        target = "quickshell";
        ignorelinks = true;
      };

      home.file = {
        shellqml = {
          enable = false;
          target = "./.config/quickshell/shell.qml";
          source = pkgs.writeTextFile {
            text = builtins.readFile ./qsConfig/shell.qml;
            name = "shell.qml";
          };
        };

        settings = {
          enable = false;
          target = "./.config/quickshell/Commons/Settings.qml";
          source = pkgs.writeTextFile {
            name = "Settings.qml";
            text = settingsText;
          };
        };
        settingsDev = {
          enable = true;
          target = "${cfg.developerMode.path}/Commons/Settings.qml";
          source = pkgs.writeTextFile {
            name = "Settings.qml";
            text = settingsText;
          };
        };
      };
    };
  };
}
