{ config, pkgs, lib ? pkgs.lib, ... }:

with lib;

let
  cfg = config.services.cnn-mnist;
  pkg = import ./default.nix;
in
{
  # Interface

  options = {
    services.cnn-mnist = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable cnn-mnist service.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          Port to use.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Host to use.
        '';
      };

      backend = mkOption {
        type = types.enum [ "theano" "tensorflow" ];
        default = "tensorflow";
        description = ''
          Keras backend to use.
        '';
      };

      model = mkOption {
        type = types.path;
        default = "${pkg.model}/model.h5";
        description = ''
          Path to the Keras model file.
        '';
      };

    };
  };


  # Implementation

  config = mkIf cfg.enable {

    systemd.services.cnn-mnist = { 
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gcc ];
      environment = {
        MODEL = cfg.model;
        PORT  = toString cfg.port;
        HOST  = cfg.host;
      };
      serviceConfig = { 
        ExecStart = "${pkg.frontend.override{ backend = cfg.backend; }}/bin/cnn-mnist";
        Restart   = "always";
      };
      postStart = ''
        until ${pkgs.curl.bin}/bin/curl -s -o /dev/null ${cfg.host}:${toString cfg.port}; do
          sleep 1
        done
      '';
    };

  };
}
