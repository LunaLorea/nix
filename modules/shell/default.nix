{
  host,
  pkgs,
  lib,
  config,
  ...
}: {
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
    ];

    # Set default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [zsh];
    environment.pathsToLink = ["/share/zsh"];

    home-manager.users.${host.userName} = {...}: {
      programs = {
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            ll = "ls -l";
            rebuild = "sudo nixos-rebuild switch --flake /home/${host.userName}/.config/nix#${host.hostName}";
            update = "nix flake update --flake /home/${host.userName}/.config/nix#laptop";
            tree = "eza --tree --level=5";
          };
          history.size = 10000;

          oh-my-zsh = {
            enable = true;
            plugins = ["git" "fzf" "git"];
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
      };
    };
  };
}
