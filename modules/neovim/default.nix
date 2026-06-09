{
  lib,
  config,
  inputs,
  host,
  pkgs,
  ...
}:
let
  cfg = config.modules.neovim;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    ;

  yuck = pkgs.vimUtils.buildVimPlugin {
    pname = "yuck.vim";
    version = "1";

    src = pkgs.fetchFromGitHub {
      owner = "elkowar";
      repo = "yuck.vim";
      rev = "9b5e0370f70cc30383e1dabd6c215475915fe5c3";
      hash = "sha256-F7aS8d6jJQQoIGkG2o4KNnDZAIrq0c+otIHvjdoGbtY=";
    };
  };
in
{
  options.modules.neovim = {
    enable = mkEnableOption "Neovim";
  };

  imports = [
    inputs.nvf.nixosModules.default
  ];

  config = mkIf cfg.enable {
    home-manager.users.${host.userName} = { ... }: {
      home.packages = with pkgs; [
        (treefmt.withConfig {
          runtimeInputs = [
            nixfmt
            black
            prettier
            rustfmt
            tombi
            stylua
            sqruff
            kdePackages.qtdeclarative
          ];
          settings = {
            on-unmatched = "info";

            formatter = {
              # Nix
              nixfmt = {
                command = "nixfmt";
                includes = [ "*.nix" ];
              };

              # Python
              black = {
                command = "black";
                includes = [
                  "*.py"
                  "*.pyi"
                ];
              };

              # JS/TS, CSS, HTML
              prettier = {
                command = "prettier";
                includes = [
                  "*.cjs"
                  "*.css"
                  "*.html"
                  "*.js"
                  "*.json"
                  "*.jsonc"
                  "*.json5"
                  "*.jsx"
                  "*.less"
                  "*.markdown"
                  "*.md"
                  "*.mdx"
                  "*.mjs"
                  "*.sass"
                  "*.scss"
                  "*.ts"
                  "*.tsx"
                  "*.vue"
                  "*.yaml"
                  "*.yml"
                ];
                options = [ "--write" ];
              };

              # Rust
              rustfmt = {
                command = "rustfmt";
                includes = [ "*.rs" ];
                options = [
                  "--config"
                  "skip_children=true"
                  "--edition"
                  "2024"
                ];
              };

              # TOML
              tombi = {
                command = "tombi";
                includes = [ "*.toml" ];
                options = [ "format" ];
              };

              # Lua
              stylua = {
                command = "stylua";
                includes = [ "*.lua" ];
              };

              # SQL
              sqruff = {
                command = "sqruff";
                includes = [ "*.sql" ];
                options = [ "fix" ];
              };

              # QML
              qmlformat = {
                command = "qmlformat";
                includes = [ "*.qml" ];
                options = [
                  "--inplace"
                  "--indent-width=${lib.toString config.programs.nvf.settings.vim.options.tabstop}"
                ];
              };
            };
          };
        })
      ];
    };

    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          startPlugins = [ yuck ];

          languages = {
            nix.enable = true;
            python.enable = true;
            rust.enable = true;
            typescript.enable = true;
            bash.enable = true;
            lua.enable = true;
            java = {
              enable = true;
              extensions.maven-nvim.enable = true;
            };
            json.enable = true;
            clang.enable = true;
            css.enable = true;
            html.enable = true;
            yaml.enable = true;
            markdown.enable = true;
            qml.enable = true;

            enableTreesitter = true;
          };

          options = {
            tabstop = 2;
            softtabstop = 2;
            shiftwidth = 0;
            autoindent = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
          };

          formatter.conform-nvim = {
            # https://github.com/stevearc/conform.nvim
            enable = true;
            setupOpts.formatters_by_ft."*" = [ "treefmt" ]; # "*" matches all files as treefmt handles all formatting
          };

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
