{
  network.description = "NixOps module example";

  webserver = { config, pkgs, ... }:
    let
      # 外部モジュールの宣言
      binserverSrc = (import <nixpkgs> {}).fetchFromGitHub {
          owner  = "ericsagnes";
          repo   = "binserver";
          rev    = "v1.0";
          sha256 = "1nhlmchh7565vcx68lscn0g9agxk5vk3bkr7h3a3fwwl696prbjb";
      };
    in
    { 

      # 外部モジュールの呼び出し
      # https://github.com/ericsagnes/binserver/blob/v1.0/module.nix
      imports = [ "${binserverSrc}/module.nix" ]; 

      # binserverサービスの有効
      # 自動的にbinserverパッケージをビルド
      services.binserver.enable = true;

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
                proxy_pass          http://127.0.0.1:8080;
                proxy_http_version  1.1;
              }
            }
          }
        '';
      };

    };
}
