/*

  binserverのNixOSコンテナーを作る。nginxのリバースプロキシとホスト登録も行います。
  使うにはこのファイルを /etc/nixos/configuration.nix の imports 宣言に登録すればいいです:

    imports = [
      /path/to/this/file/container.nix
    ];

  
  リビルトして、設定を反映:

    $ nixos-rebuild switch

*/
{ config, lib, pkgs, ... }:

let
  name    = "binserver";
  domain  = "binserver.org";
in
rec {
  /* Container declaration
  */
  containers."${name}" = {
    privateNetwork = true;
    hostAddress    = "10.0.0.1";
    localAddress   = "10.0.0.2";
 
    autoStart = true;

    config = { config, pkgs, ... }: { 
      imports = [ ./module.nix ];
      services.binserver.enable = true;
      networking.firewall.allowedTCPPorts = [ 8080 ];
    };
  };

  /* Reverse proxy (host NixOS setting)
  */
  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen 80;
        server_name ${domain};
        location / {
          proxy_pass          http://${name}:8080;
          proxy_http_version  1.1;
        }
      }
    '';
  };

  /* Host entry & firewall setting (host NixOS setting)
  */
  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    extraHosts = ''
      127.0.0.1    ${domain}
    '';
  };
}
