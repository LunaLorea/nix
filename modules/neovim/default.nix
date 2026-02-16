{
  lib,
  config,
  inputs,
  host,
  ...
}: let
  cfg = config.modules.neovim;
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    ;
in {
  options.modules.neovim = {
    enable = mkEnableOption "Neovim";
  };

  imports = [
    inputs.nvf.nixosModules.default
  ];

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          languages = {
            nix.enable = true;
            python.enable = true;
            rust.enable = true;
            ts.enable = true;
            bash.enable = true;
            lua.enable = true;
            java.enable = true;
            json.enable = true;
            clang.enable = true;
            css.enable = true;
            html.enable = true;
            yaml.enable = true;
            markdown.enable = true;
            qml.enable = true;

            enableFormat = true;
            enableTreesitter = true;
          };

          options = {
            tabstop = 2;
            softtabstop = 2;
            shiftwidth = 0;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
          };

          theme.name = "catppuccin";

          undoFile = {
            enable = true;
            path = "/home/${host.userName}/.vim/undodir";
          };

          utility = {
            undotree.enable = true;
            surround.enable = true;
          };

          telescope = {
            enable = true;
          };

          terminal.toggleterm = {
            enable = true;
          };

          statusline.lualine.enable = true;

          git = {
            gitsigns.enable = true;
          };

          filetree.nvimTree.enable = true;

          ui = {
            colorizer.enable = true;
            smartcolumn.setupOpts.colorcolumn = 80;
          };

          keymaps = [
            {
              key = "<leader>u";
              mode = "n";
              action = "<cmd>UndotreeToggle<CR>";
            }
          ];

          lineNumberMode = "relNumber";
          searchCase = "smart";

          clipboard.enable = true;
        };
      };
    };
  };
}
