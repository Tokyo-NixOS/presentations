{
  webserver =
    { config, pkgs, ... }:
    { 
      deployment = { 
        targetEnv  = "none";
        # NixOSリモートサーバのIP
        targetHost = "1.2.3.4";
      };
    };
}
