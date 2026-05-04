# Setup based on https://trash-guides.info/Hardlinks/How-to-setup-for/Native/#torrent-clients
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    getExe
    mkIf
    mkEnableOption
    ;

  cfg = config.modules.server.arr;
  netns = "proton";
in {
  options.modules.server.arr = {
    enable = mkEnableOption "qbittorrent module";
  };
  imports = [inputs.vpn-confinement.nixosModules.default];
  config = mkIf cfg.enable {
    users.groups.media = {};
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [8043 3890 9001 9200 8122];
      allowPing = true;
    };
    services = {
      audiobookshelf = {
        enable = true;
        host = "0.0.0.0";
        port = 8000;
        openFirewall = true;
        dataDir = "audiobookshelf";
      };
      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      seerr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      radarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      bazarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      lidarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      qbittorrent = {
        enable = true;
        # To give qBittorrent access to /mnt/media/data, and make hardlinks work
        group = "media";
        webuiPort = 8080;
        torrentingPort = 4096;
        openFirewall = true;
        serverConfig = {
          BitTorrent.Session = {
            ## Limits
            # 80% of max speed in the VPN
            GlobalDLSpeedLimit = 432000;
            GlobalUPSpeedLimit = 184000;
            # http://infinite-source.de/az/az-calc.html
            MaxConnections = 1200;
            MaxConnectionsPerTorrent = 111;
            MaxUploads = 14;
            MaxUploadsPerTorrent = 14;
            ## Automatic torrent management
            DisableAutoTMMByDefault = false;
            DisableAutoTMMTriggers = {
              CategorySavePathChanged = false;
              DefaultSavePathChanged = false;
            };
            ## Paths
            DefaultSavePath = "/mnt/pool/media/torrents";
            ## Misc.
            BTProtocol = "TCP";
            Preallocation = true;
            QueueingSystemEnabled = false;
          };
          Core.AutoDeleteAddedTorrentFile = "IfAdded";
          LegalNotice.Accepted = true;
          Meta.MigrationVersion = 6;
          Network.PortForwardingEnabled = false;
          Preferences = {
            General.Locale = "en";
            WebUI = {
              Username = "admin";
              Password_PBKDF2 = "m92jiZsmBS3w3vlUzgT+Mw==:GxK/fjsirr2KXtwDzyBKbo82jSpLctb8UvsG2GLxgUOI+fcPi7gjDh87rS8WEo/32iSUaQM6WI5pYGOJLrgz2Q==";
            };
          };
        };
      };
    };

    vpnNamespaces.proton = {
      enable = true;
      wireguardConfigFile = config.sops.templates.wireguard-config-file.path;
      accessibleFrom = [
        "192.168.178.0/24"
        "127.0.0.1/32"
      ];
      # Make qBittorrent web UI accessible on the bridge interface
      portMappings = let
        qbittorrent = config.services.qbittorrent;
      in [
        {
          from = qbittorrent.webuiPort;
          to = qbittorrent.webuiPort;
        }
        {
          # Lidarr
          from = 8686;
          to = 8686;
        }
        {
          # Prowlarr
          from = 9696;
          to = 9696;
        }
        {
          # Radarr
          from = 7878;
          to = 7878;
        }
        {
          # Readarr
          from = 8787;
          to = 8787;
        }
        {
          # Sonarr
          from = 8989;
          to = 8989;
        }
        {
          # seer
          from = 5055;
          to = 5055;
        }
      ];
    };

    systemd.services = let
      customCreateShellScript = {
        pkgs,
        pname,
        src,
        version ? "1.0",
        deps,
      }:
        pkgs.stdenv.mkDerivation {
          inherit pname src version;

          nativeBuildInputs = [pkgs.makeWrapper];

          phases = ["installPhase"];

          installPhase = ''
            mkdir -p $out/bin
            install -m +x $src $out/bin/${pname}

            wrapProgram $out/bin/${pname} \
              --prefix PATH : ${lib.makeBinPath deps}
          '';

          meta.mainProgram = pname;
        };

      qbittorrent-vpn-port-update = customCreateShellScript {
        inherit pkgs;

        pname = "qbittorrent-vpn-port-update";
        src = ./script.sh;
        deps = with pkgs; [
          curl
          gawk
          iptables
          jq
          libnatpmp
        ];
      };
    in {
      qbittorrent = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = "proton";
        };
      };
      # Automatically update the qBittorrent torrenting port with the one forwarded in ProtonVPN
      qbittorrent-vpn-port-update = {
        enable = true;
        description = "Automatically update the qBittorrent torrenting port with the one forwarded in ProtonVPN";
        after = ["qbittorrent.service"];
        requires = ["qbittorrent.service"];
        wantedBy = ["multi-user.target"];
        environment = {
          # The VPN connection interface
          VPN_INTERFACE = "${netns}0";
          QBITTORRENT_WEBUI_HOST = "127.0.0.1";
          QBITTORRENT_WEBUI_PORT = toString config.services.qbittorrent.webuiPort;
          QBITTORRENT_WEBUI_USERNAME = "admin";
          QBITTORRENT_WEBUI_PASSWORD_FILE = "/run/secrets/hosts/myriorama/qbittorrent/password";
          INITIAL_DELAY_SEC = "10";
          CHECK_INTERVAL_SEC = "60";
          ERROR_INTERVAL_SEC = "5";
          ERROR_INTERVAL_COUNT = "5";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = getExe qbittorrent-vpn-port-update;
        };
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };

      lidarr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
      prowlarr = {
        # Make Prowlarr run in the VPN namespace so it has the same IP as qBittorrent
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
      radarr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
      readarr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
      sonarr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
      seerr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = netns;
        };
      };
    };

    sops = {
      templates.wireguard-config-file = {
        content =
          # ini
          ''
            [Interface]
            # Key for myriorama
            # Bouncing = 5
            # NetShield = 1
            # Moderate NAT = off
            # NAT-PMP (Port Forwarding) = on
            # VPN Accelerator = on
            PrivateKey = ${config.sops.placeholder."hosts/myriorama/protonvpn/private_key"}
            Address = 10.2.0.2/32
            DNS = 10.2.0.1

            [Peer]
            # CH#631
            PublicKey = snSASVcKZegpITPNw2scm44NBC6NPUropoTkfEGtq18=
            AllowedIPs = 0.0.0.0/0
            Endpoint = 79.127.184.1:51820
          '';
        owner = "qbittorrent";
      };
      secrets."hosts/myriorama/protonvpn/private_key".owner = "qbittorrent";
      secrets."hosts/myriorama/qbittorrent/password".owner = "qbittorrent";
    };
  };
}
