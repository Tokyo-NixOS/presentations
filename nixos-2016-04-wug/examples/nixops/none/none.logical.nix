{
  network.description = "NixOps none example";

  webserver = { config, pkgs, ... }:
    { 
      # リモートNixOSのconfiguration.nix
      # hardware-configuration.nixも必要
      imports = [ ./configuration.nix ];  
    };

}
