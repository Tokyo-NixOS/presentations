{ config, pkgs, ... }:
let 
  domain = "hydra.example.org";
in
{ 
  # enable Hydra
  services.hydra = {
    enable = true;
    hydraURL = domain;
    notificationSender = "admin@${domain}";
    buildMachinesFiles = [ "/etc/nix/machines" ];

    # use binary cache for already builded packages
    useSubstitutes = true;
  };

  # nix daemon settings
  nix = {
    # enable distributed builds
    distributedBuilds = true;
    # distributed builds machines
    buildMachines = [
      { hostName = "slave1"; maxJobs = 2; speedFactor = 1; sshKey = "/etc/nix/id_buildfarm"; sshUser = "root"; system = "x86_64-linux"; }
      { hostName = "slave2"; maxJobs = 2; speedFactor = 1; sshKey = "/etc/nix/id_buildfarm"; sshUser = "root"; system = "i686-linux"; }
    ];

    extraOptions = "auto-optimise-store = true";
    useSandbox= true;
    nrBuildUsers = 30;
  };

  # Sending the ssh key to the machine
  environment.etc."nix/id_buildfarm" = {
    source = ./id_buildfarm;
    uid    = config.ids.uids.hydra;
    gid    = config.ids.gids.hydra;
    mode   = "640";
  };

  # Ensure that Hydra related uids and gids are correct
  users.users.hydra-www.uid = config.ids.uids.hydra-www;
  users.users.hydra-queue-runner.uid = config.ids.uids.hydra-queue-runner;
  users.users.hydra.uid = config.ids.uids.hydra;
  users.groups.hydra.gid = config.ids.gids.hydra;

  # opening port 80 for Hydra server
  networking.firewall.allowedTCPPorts = [ 80 ];

  # reverse proxy to Hydra
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
