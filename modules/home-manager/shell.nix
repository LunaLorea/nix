{
  colors,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neofetch
  ];

  programs = {
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Macchiato";
      settings = {
        background_opacity = "0.8";
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      # bashrcExtra = ''eval "$(oh-my-posh init bash)"'';
      # initExtra = ''neofetch'';
      shellAliases = {
        tree = "eza --tree --level=5";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch --flake /home/luna/.config/nix#laptop";
        update = "nix flake update --flake /home/luna/.config/nix#laptop";
      };
      history.size = 10000;

      oh-my-zsh = { 
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };

    oh-my-posh = {
      enable = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # useTheme = "M365Princess";
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (
      ''{
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "palette": {
          "white": "${colors.base}",
          "tan": "#CC3802",
          "teal": "${colors.teal}",
          "plum": "${colors.mauve}",
          "blush": "${colors.red}",
          "salmon": "${colors.peach}",
          "sky": "${colors.sky}",
          "teal_blue": "${colors.sapphire}"
        },
        "auto_upgrade": false,
        "blocks": [
          {
            "alignment": "left",
            "segments": [
              {
                "type": "text",
                "style": "diamond",
                "leading_diamond": "\ue0b6",
                "foreground": "p:white",
                "background": "p:tan",
                "template": "{{ if .Env.PNPPSHOST }} \uf8c5 {{ .Env.PNPPSHOST }} {{ end }}"
              },
              {
                "type": "text",
                "style": "powerline",
                "foreground": "p:white",
                "background": "p:teal",
                "powerline_symbol": "\ue0b0",
                "template": "{{ if .Env.PNPPSSITE }} \uf2dd {{ .Env.PNPPSSITE }}{{ end }}"
              },
              {
                "type": "text",
                "style": "diamond",
                "trailing_diamond": "\ue0b4",
                "foreground": "p:white",
                "background": "p:teal",
                "template": "{{ if .Env.PNPPSSITE }}\u00A0{{ end }}"
              }
            ],
            "type": "rprompt"
          },
          {
            "alignment": "left",
            "segments": [
        {
           "type": "nix-shell",
           "style": "diamond",
           "leading_diamond": "\ue0b6",
           "foreground": "p:white",
           "background": "p:teal",
           "template": "(nix-{{ .Type }})"
        },
              {
                "background": "p:plum",
                "foreground": "p:white",
                "powerline_symbol": "\ue0b0",
          "style": "powerline",
                "template": "{{ .UserName }} ",
                "type": "session"
              },
              {
                "background": "p:blush",
                "foreground": "p:white",
                "powerline_symbol": "\ue0b0",
                "properties": {
                  "style": "folder"
                },
                "style": "powerline",
                "template": " {{ .Path }} ",
                "type": "path"
              },
              {
                "background": "p:salmon",
                "foreground": "p:white",
                "powerline_symbol": "\ue0b0",
                "properties": {
                  "branch_icon": "",
                  "fetch_stash_count": true,
                  "fetch_status": false,
                  "fetch_upstream_icon": true
                },
                "style": "powerline",
                "template": " \u279c ({{ .UpstreamIcon }}{{ .HEAD }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }}) ",
                "type": "git"
              },
              {
                "background": "p:sky",
                "foreground": "p:white",
                "powerline_symbol": "\ue0b0",
                "style": "powerline",
                "template": " \ue718 {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }} ",
                "type": "node"
              }
              
            ],
            "type": "prompt"
          }
        ],
        "final_space": true,
        "version": 2
      }''
      ));
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
