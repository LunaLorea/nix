{ config, pkgs, ... }:

{
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
        ${builtins.readFile ./neovim/options.lua}
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
	config = toLuaFile ./neovim/telescope.lua;
      }
      
      rose-pine
      harpoon
      undotree
      vim-fugitive
      lsp-zero-nvim
      cmp-nvim-lsp
      nvim-lspconfig
      nvim-cmp
      vim-lsp
      luasnip

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
      ]))
    ];

  };
  home.packages = with pkgs; [
    clang-tools
    nixd
    lua-language-server
  ];
}
