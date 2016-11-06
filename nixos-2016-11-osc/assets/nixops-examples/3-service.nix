let
  nixpasteSrc = (import <nixpkgs> {}).fetchFromGitHub {
    owner  = "lethalman";
    repo   = "nixpaste";
    rev    = "cb06cbd";
    sha256 = "1rigdl8m78zzbalaaf4s07m7r02rh2gjlhh4215dklc6nkrpnfd5";
  };
in
{
  network.description = "OSC NixOps example";

  machine = { config, pkgs, ... }: {
    deployment = {
      targetEnv = "virtualbox";
      virtualbox = {
        memorySize = 1024;
        headless = true;
      };
    };


    networking.firewall.allowedTCPPorts = [ 80 ];

    imports = [
      "${nixpasteSrc}/nixos-module.nix"
    ];

    services.nixpaste = {
      enable = true;
      config = {
        storageDir = "/tmp";
        url = "http://localhost:8080";
      };
    };

    services.nginx = {
      enable = true;
      httpConfig = ''
        server {
          listen 80;
          location / {
            proxy_pass          http://localhost:8080;
            proxy_http_version  1.1;
          }
        }
      '';
    };

  };
}
