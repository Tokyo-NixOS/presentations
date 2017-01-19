{
  network.description = "NixOps module & container example";

  webserver = { config, pkgs, ... }:
    let
      # 外部サービスのインポート
      binserverSrc = (import <nixpkgs> {}).fetchFromGitHub {
          owner  = "ericsagnes";
          repo   = "binserver";
          rev    = "v1.0";
          sha256 = "1nhlmchh7565vcx68lscn0g9agxk5vk3bkr7h3a3fwwl696prbjb";
      };
    in
    { 

      # ポート80開放
      networking.firewall.allowedTCPPorts = [ 80 ];

      # Nginxプロクシ
      services.nginx = {
        enable = true;
        config = ''
          events {}
          http {
            server {
              listen 80;
              location / {
                proxy_pass          http://10.0.0.2:8080;
                proxy_http_version  1.1;
              }
            }
          }
        '';
      };


      # コンテナー
      containers.binserver = {
    
        privateNetwork = true;
        hostAddress    = "10.0.0.1";
        localAddress   = "10.0.0.2";

        autoStart = true;
    
        config = { config, pkgs, ... }: { 
          imports = [ "${binserverSrc}/module.nix" ];
          services.binserver.enable = true;
          networking.firewall.allowedTCPPorts = [ 8080 ];
        };

      };

  };
}
