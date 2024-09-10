{ config, pkgs, ... }:

{
  programs.firefox.profiles.messages = {
    id = 1;
    isDefault = false;
    settings = {
      "browser.startup.homepage" = "https://web.whatsapp.com/|https://web.threema.ch/#!/welcome|https://discord.com/channels/@me|https://web.telegram.org/";
    };
  };
}

