{
  host,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.modules.browser = {
    enable = lib.mkEnableOption "the browser module";
  };

  config = lib.mkIf config.modules.browser.enable {
    home-manager.users.${host.userName} = { ... }: {
      imports = [ inputs.zen-browser.homeModules.beta ];
      stylix.targets.zen-browser.profileNames = [ "default" ];
      programs.zen-browser = {
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

          ExtensionSettings =
            let
              moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            in
            {
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
              default = "ddg";
              privateDefault = "ddg";

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
                  definedAliases = [ "@np" ];
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
                  definedAliases = [ "@no" ];
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
                  definedAliases = [ "@nw" ];
                };
              };
            };

            mods = [
              "e74cb40a-f3b8-445a-9826-1b1b6e41b846" # Custom uiFont
              "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
              "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
              "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
            ];

            settings = {
              "sidebar.verticalTabs" = "true";
              "browser.toolbars.bookmarks.visibility" = "never";
              "browser.uiCustomization.navBarWhenVerticalTabs" =
                ''["back-button","forward-button","stop-reload-button","customizableui-special-spring1","vertical-spacer","urlbar-container","customizableui-special-spring2","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action"]'';
              "browser.ml.chat.enabled" = "false";
              "sidebar.main.tools" = "bookmarks";
              "font.name.monospace.x-western" = lib.mkForce "0xProto Nerd Font Mono";
              "font.name.sans-serif.x-western" = lib.mkForce "0xProto Nerd Font";
              "font.name.serif.x-western" = lib.mkForce "0xProto Nerd Font";
            };

            pinsForce = true;
            pinsForceAction = "remove";
            pins = {
              "Proton Mail" = {
                id = "proton-mail";
                url = "https://mail.protonmail.com";
                position = 100;
                isEssential = true;
              };
              "Proton Calendar" = {
                id = "proton-calendar";
                url = "https://calendar.proton.me/";
                position = 101;
                isEssential = true;
              };
            };

            spaceRouting = {
              # Link previews / external opens with no matching rule land here.
              defaultExternalRoute = "0";

              routes = {
                "codeberg" = {
                  reference = "codeberg.org";
                  openIn = "development";
                };
                "forgejo" = {
                  reference = "git.lorea.dev";
                  openIn = "development";
                };
                "github" = {
                  reference = "github.com";
                  openIn = "development";
                };

                "youtube" = {
                  reference = "youtube.com";
                  openIn = "entertainment";
                };
                "bluesky" = {
                  reference = "bsky.app";
                  openIn = "entertainment";
                };
                "mastodon" = {
                  reference = "social.lorea.dev";
                  openIn = "entertainment";
                };
              };
            };

            spacesForce = true;
            spaces = {
              Entertainment = {
                id = "entertainment";
                icon = "";
                pins = {
                  "YouTube" = {
                    id = "youtube";
                    url = "https://youtube.com/";
                    position = 102;
                  };
                  "Jellyfin" = {
                    id = "jellyfin";
                    url = "https://jellyfin.wuffli.art/";
                    position = 103;
                  };
                  "Twitch" = {
                    id = "twitch";
                    url = "https://twitch.tv/";
                    position = 104;
                  };
                };
              };
              Development = {
                id = "development";
                icon = "󰅪";
                pins = {
                  "Forgejo" = {
                    id = "forgejo";
                    url = "https://git.lorea.dev/";
                    position = 1;
                  };
                  "Codeberg" = {
                    id = "codeberg";
                    url = "https://codeberg.org/";
                    position = 2;
                  };
                  "Github" = {
                    id = "github";
                    url = "https://github.com/";
                    position = 3;
                  };
                };
              };
              Studying = {
                id = "studying";
                icon = "";
                pins = {
                  "Moodle" = {
                    id = "moodle";
                    url = "https://moodle-app2.let.ethz.ch/my/";
                    position = 1;
                  };
                  "Exam Collection" = {
                    id = "examcollection";
                    url = "https://exams.vis.ethz.ch/";
                    position = 2;
                  };
                  "MyStudies" = {
                    id = "mystudies";
                    url = "https://www.lehrbetrieb.ethz.ch/myStudies/login.view";
                    position = 3;
                  };
                  "EduApp" = {
                    id = "eduapp";
                    url = "https://eduapp.ethz.ch/";
                    position = 4;
                  };
                };
              };
              Work = {
                id = "work";
                icon = "󰙸";
                pins = {
                  "Confluence" = {
                    id = "confluence";
                    url = "https://unlimited.ethz.ch/spaces/CSNOW/pages/491520264/HS26+27+-+Semester+Dashboard";
                    position = 1;
                  };
                  "CSNOW Mail" = {
                    id = "csnow-mail";
                    url = "https://outlook.office.com/mail/infkdeptcsnow@ethz.mail.onmicrosoft.com/";
                    position = 2;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
