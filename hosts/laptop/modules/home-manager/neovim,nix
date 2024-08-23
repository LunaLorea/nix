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
        ${builtins.readFile ./nvim/options.lua}
    '';

    plugins = with pkgs.vimPlugins; [

      (nvim-treesitter.withPlugins (p: [
        p.trees-sitter-nix
        p.trees-sitter-vim
        p.trees-sitter-bash
        p.trees-sitter-lua
        p.trees-sitter-python
        p.trees-sitter-java
        p.trees-sitter-json
      ]))

      vim-nix

    ];

  };

}
