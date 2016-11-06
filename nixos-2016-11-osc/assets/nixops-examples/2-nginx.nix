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

    services.nginx = {
      enable = true;
      httpConfig = ''
        server {
          listen 80;
          location / {
            root ${pkgs.nginx}/html;
          }
        }
      '';
    };

  };
}
