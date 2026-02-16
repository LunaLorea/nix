nixpkgs: path: (map (x: import x) (
  nixpkgs.lib.filter (x: nixpkgs.lib.hasSuffix ".nix" x) (
    nixpkgs.lib.filesystem.listFilesRecursive path
  )
))
