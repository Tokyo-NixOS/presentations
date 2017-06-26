{
  network.description = "cnn-mnist virtualbox deployment";

  frontend = { config, pkgs, ... }: { 

    /* Deployment information
       Can be moved in a separate file
    */
    deployment = {
      targetEnv = "virtualbox";
      virtualbox.memorySize = 1024;
      virtualbox.headless = true;
    };

    # Import our module
    imports = [ ./module.nix ];

    # enabling the module service
    services.cnn-mnist.enable = true;

    # Opening port 80
    networking.firewall.allowedTCPPorts = [ 80 ];
 
    # Nginx frontend 
    services.nginx = {
      enable = true;
      httpConfig = ''
        server {
          listen 80;
          location / {
            proxy_pass          http://127.0.0.1:8080;
            proxy_http_version  1.1;
          }
        }
      '';
    };

  };
}
