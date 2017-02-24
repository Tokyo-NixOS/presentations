/* 
  binserver NixOS module, it can be imported in /etc/nixos/configuration.nix, and the options can be used.
  To use, link this file in /etc/nixos/configuration.nix imports declaration, example:

    imports = [
      /path/to/this/file/module.nix
    ];

  Enable the module option:

    services.binserver.enable = true;
    networking.firewall.allowedTCPPorts = [ 8080 ];

  And rebuild the configuration:

    $ nixos-rebuild switch

  Documentation: https://nixos.org/nixos/manual/index.html#sec-writing-modules

  ---

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
  /* Using the binserver build file in this directory
     このフォルダーのビルドファイルを利用する
  */
  binserverPackage = (import ./. {});
in
{
  /* Declaration of module options 
     モジュールオプション宣言
  */
  options = {
    services.binserver = {
      enable = mkEnableOption "binserver";
    };
  };

  /* Module logic
     モジュールロジック
  */
  config = mkIf cfg.enable {
    environment.systemPackages = [ binserverPackage ];

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
