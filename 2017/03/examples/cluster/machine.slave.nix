{ config, pkgs, ... }:
{ 
  # nix daemon settings
  nix = {
    useSandbox= true;
    nrBuildUsers = 30;
    maxJobs = 5;
  };

  # enable openssh
  services.openssh.enable = true;

  # copy the public key
  users.extraUsers.root.openssh.authorizedKeys.keys = [ (builtins.readFile ./id_buildfarm.pub) ];

}
