{
  host,
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.shell = {
    enable = lib.mkEnableOption "the shell module";
  };

  config = lib.mkIf config.modules.shell.enable {
    environment.systemPackages = with pkgs; [
      # Easier to read man pages
      tldr
      # Replacaement for ls
      eza
      # wget
      wget

      openssh

      alejandra
    ];

    # Set default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh ];
    environment.pathsToLink = [ "/share/zsh" ];

    security.sudo-rs.enable = true;
    security.sudo.enable = false;

    home-manager.users.${host.userName} = _: {
      programs = {
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          # Set to comply with default behavior from 26.05
          dotDir = "${config.home-manager.users.${host.userName}.xdg.configHome}/zsh";

          shellAliases = {
            ll = "eza -l --git";
            rebuild = "nixos-rebuild switch --flake /home/${host.userName}/.config/nix#${host.hostName} --ask-sudo-password";
            update = "nix flake update --flake /home/${host.userName}/.config/nix";
            nixgc = "sudo nix-collect-garbage --delete-older-than 7d && sudo nix-store --gc && nix-store --optimise";
            tree = "eza --tree --level=5 -l --git";
          };
          history.size = 10000;

          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "fzf"
              "git"
            ];
            theme = "robbyrussell";
          };
        };

        tmux = {
          enable = true;
          clock24 = true;
        };

        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        git = {
          enable = true;
          settings = {
            user = {
              email = "git@lunalorea.ch";
              name = "Luna Zehnder";
            };
          };
          signing = {
            signByDefault = true;
            signer = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
            format = "ssh";
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvuUjUHkdOUt5yK7SwUa6hv/08FdbYsFjJeUbGFx88S";
          };
        };

        man = {
          enable = true;
          generateCaches = true;
        };
      };

      manual.manpages.enable = true;

    };
  };
}
