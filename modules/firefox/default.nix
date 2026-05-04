{
  host,
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.firefox = {
    enable = lib.mkEnableOption "the firefox module";
  };

  config = lib.mkIf config.modules.firefox.enable {
    home-manager.users.${host.userName} = {...}: {
      programs.firefox = {
        enable = true;
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableForgetButton = true;
          DisableProfileImport = true;
          DisableProfileRefresh = true;
          DisableSetDesktopBackground = true;
          DisableFormHistory = true;

          DisplayMenuBar = "never";
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;

          ExtensionSettings = let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in {
            "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            # uBlock Origin:
            "uBlock0@raymondhill.net" = {
              install_url = moz "ublock-origin";
              installation_mode = "force_installed";
            };
            # Privacy Badger:
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = moz "privacy-badger17";
              installation_mode = "force_installed";
            };
            # Improve Youtube
            "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
              install_url = moz "youtube-addon";
              installation_mode = "force_installed";
            };
            # Bitwarden Client
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = moz "bitwarden-password-manager";
              installation_mode = "force_installed";
            };
            # Sponser Block
            "sponsorBlocker@ajay.app" = {
              install_url = moz "sponsorblock";
              installation_mode = "force_installed";
            };
          };

          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net".adminSettings = {
              userSettings = rec {
                uiTheme = "dark";
                uiAccentCustom = true;
                uiAccentCustom0 = "#8300ff";
                cloudStorageEnabled = lib.mkForce false;

                importedLists = [
                  "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
                  "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                ];

                externalLists = lib.concatStringsSep "\n" importedLists;
              };

              selectedFilterLists = [
                "CZE-0"
                "adguard-generic"
                "adguard-annoyance"
                "adguard-social"
                "adguard-spyware-url"
                "easylist"
                "easyprivacy"
                "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                "plowe-0"
                "ublock-abuse"
                "ublock-badware"
                "ublock-filters"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "urlhaus-1"
              ];
            };
          };
        };
        profiles = {
          default = {
            name = "default";
            search = {
              force = true;
              default = "DuckDuckGo";
              privateDefault = "DuckDuckGo";

              engines = {
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@np"];
                };

                "Nix Options" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@no"];
                };

                "NixOS Wiki" = {
                  urls = [
                    {
                      template = "https://wiki.nixos.org/w/index.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@nw"];
                };
              };
            };

            settings = {
              "sidebar.verticalTabs" = "true";
              "browser.toolbars.bookmarks.visibility" = "never";
              "browser.uiCustomization.navBarWhenVerticalTabs" = ''["back-button","forward-button","stop-reload-button","customizableui-special-spring1","vertical-spacer","urlbar-container","customizableui-special-spring2","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action"]'';
              "browser.ml.chat.enabled" = "false";
              "sidebar.main.tools" = "bookmarks";
            };
          };
        };
      };
    };
  };
}
