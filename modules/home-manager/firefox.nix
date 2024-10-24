{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        name = "default";
      };
      messages = {
        id = 1;
        isDefault = false;
        settings = {
          "browser.startup.homepage" = "https://web.whatsapp.com/|https://web.threema.ch/#!/welcome|https://discord.com/channels/@me|https://web.telegram.org/";
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
      exec = "firefox -P messages -no-remote";
      icon = builtins.path {path = ../../media/messages_icon.png;};
    };
  };
}
