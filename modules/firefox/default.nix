{
  host,
  config,
  lib,
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
            Value= true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          ExtensionSettings = {
            "*".installation_mode = "normal"; # blocks all addons except the ones specified below
              # uBlock Origin:
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };
              # Privacy Badger:
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
              installation_mode = "force_installed";
            };
              # 1Password:
            "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
              # Catppuccin theme
            "{15cb5e64-94bd-41aa-91cf-751bb1a84972}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-macchiato-lavender2/latest.xpi";
              installation_mode = "force_installed";
            };
            # Improve Youtube
            "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-addon/latest.xpi";
              installation_mode = "force_install";
            };
          };
        };
        profiles = {
          default = {
            name = "default";
          };
          messages = {
            id = 1;
            isDefault = false;
            settings = {
              "browser.startup.homepage" = "https://web.whatsapp.com/|https://web.threema.ch/#!/welcome|https://web.telegram.org/|https://mail.proton.me/";
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
              "sidebar.revamp" = true;
              "sidebar.verticalTabs" = true;
              "sidebar.main.tools" = "";
              "layout.css.prefers-color-scheme.content-override" = 0;
            };
            userChrome = ''
              /* Hide different gui items*/
              #nav-bar,
              #navigator-toolbox,
              #newtab-button-container  {
                visibility: collapse !important;
              }
            '';
          };
        };
      };

      xdg.desktopEntries = {
        messages = {
          name = "Messages";
          exec = "firefox -P messages -no-remote --name Firefox-messages";
          icon = builtins.path {path = ./media/messages_icon.png;};
        };
      };
    };
  };
}
