{ config, pkgs, ... }:
let 
  domain = "hydra.example.org";
in
{ 
  services.hydra = {
    enable = true;
    hydraURL = domain;
    notificationSender = "admin@${domain}";

    # use binary cache for already builded packages
    useSubstitutes = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen 80;
        server_name ${domain};
        location / {
          proxy_pass          http://127.0.0.1:3000;
          proxy_set_header    Host    $host;
          proxy_http_version  1.1;
        }
      }
    '';
  };
}
