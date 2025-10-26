{
  lib,
  pkgs,
  ...
}: let
  sourceQscfg = lib.filter filterGenerated (lib.map (builtins.toString) (lib.filesystem.listFilesRecursive ./qsConfig));
  filterGenerated = item: !(lib.strings.hasInfix "Settings" item) && !(lib.strings.hasInfix "Colors" item);

  turnIntoFiles = path: {
    name = ''${lib.lists.last (lib.strings.splitString "/" (builtins.toString path))}'';
    value = {
      enable = true;
      target = "./.config/quickshell${lib.strings.removePrefix (builtins.toString ./qsConfig) path}";
      source = path;
    };
  };

  putConfigIntoDir = lib.listToAttrs (lib.map turnIntoFiles sourceQscfg);
in {
  home.file = putConfigIntoDir;
}
