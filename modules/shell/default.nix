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

    home-manager.users.${host.userName} = _: {
      programs = {
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            ll = "eza -l --git";
            rebuild = "alejandra /home/${host.userName}/.config/nix/. && sudo nixos-rebuild switch --flake /home/${host.userName}/.config/nix#${host.hostName} --sudo && kill $(qs list --all | grep 'Process ID:' | awk 'NR=1 {print $3}') && swaymsg exec qs";
            update = "nix flake update --flake /home/${host.userName}/.config/nix";
            nixgc = "sudo nix-collect-garbage --delete-older-than 7d && sudo nix-store --gc && nix-store --optimise";
            tree = "eza --tree --level=5 -l --git";
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
