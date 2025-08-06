{ pkgs ? import <nixpkgs> { } }:

with pkgs;

stdenv.mkDerivation {
  pname = "lightdm-web-greeter";
  version = "0.1";
  

  src = builtins.fetchGit {
    url = "https://github.com/JezerM/web-greeter.git";
    rev = "0bfa7f0036b2336c4d9aa9ad35e0777ab0b41857";
    submodules = true;
  };


  buildInputs = [
    rsync
    typescript
    python313Packages.pygobject3
    python313Packages.pyqt5
    python313Packages.pyqtwebengine
    python313Packages.ruamel-yaml
    python313Packages.inotify
    libsForQt5.qt5.qtwebengine
    gobject-introspection
    xorg.libxcb
    xorg.libX11
    pkg-config
  ];
  nativeBuildInputs = [
    libsForQt5.qt5.wrapQtAppsHook
  ];

  makeFlags = [
    "PREFIX=$(out)/usr"
    "DESTDIR=$(out)"
    ''DISTRO=nixos''
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-quiet "/etc/os-release" ""
  '';

  configurePhase = ''
    echo listing files
    ls -l themes
  '';
}

