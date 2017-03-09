/* 

  binserver用のNixOSモジュール./etc/nixos/configuration.nixでインポートして、宣言オプションを利用できます。

  使うには、このファイルを /etc/nixos/configuration.nix の imports に追加:

    imports = [
      /path/to/this/file/module.nix
    ];

  オプションを有効:

    services.binserver.enable = true;
    networking.firewall.allowedTCPPorts = [ 8080 ];

  リビルトして、設定を反映:

    $ nixos-rebuild switch

  ドキュメンテーション: https://nixos.org/nixos/manual/index.html#sec-writing-modules

*/

{ config, pkgs, lib ? pkgs.lib, ... }:

with lib;

let
  cfg = config.services.binserver;
  /* 
     このフォルダーのビルドファイルを利用する
  */
  binserverPackage = (import ./. {});
in
{
  /* 
     モジュールオプション宣言
  */
  options = {
    services.binserver = {
      enable = mkEnableOption "binserver";
    };
  };

  /* 
     モジュールロジック
  */
  config = mkIf cfg.enable {
    systemd.services.binserver = { 
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { 
        ExecStart = "${binserverPackage}/bin/binserver";
        Restart   = "always";
      };
    };
  };
}
