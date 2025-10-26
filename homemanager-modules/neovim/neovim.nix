{pkgs, ...}: {
  programs.neovim = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      #      {
      #	plugin = some-plugin;
      #	config = toLua "some lua command";
      #      }
      #      {
      #	plugin = some-plugin;
      #	config = toLuaFile ./some/path/to/config;
      #      }
      #      {
      #	plugin = some-plugin;
      #	config = "vimScript 1 liner"
      #      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./telescope.lua;
      }
      # Theme
      catppuccin-nvim
      rose-pine

      # Lualine for a better statusline
      lualine-nvim

      # Quickly switch between Files
      harpoon

      # Undo Tree. Duh.
      undotree

      # git client
      vim-fugitive

      # Language servers
      lsp-zero-nvim
      cmp-nvim-lsp
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      vim-lsp
      luasnip

      # Latex auto compile automation
      knap
      # File Tree
      nvim-tree-lua

      nvim-colorizer-lua

      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-python
        p.tree-sitter-java
        p.tree-sitter-json
        p.tree-sitter-c
        p.tree-sitter-cpp
        p.tree-sitter-css
        p.tree-sitter-html
        p.tree-sitter-javascript
        p.tree-sitter-typescript
        p.tree-sitter-latex
        p.tree-sitter-glsl
        p.tree-sitter-qmljs
      ]))
    ];
  };

  home.packages = with pkgs; [
    # Language Servers
    clang-tools
    nixd
    lua-language-server
    texlab
    glsl_analyzer
    qt6.full

    #HTML/CSS/JSON/ESLint language servers extracted from vscode.
    vscode-langservers-extracted

    # Code Formatter
    alejandra
    typescript-language-server
  ];
}
