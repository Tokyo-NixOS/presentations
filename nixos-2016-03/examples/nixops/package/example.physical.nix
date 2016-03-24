{
  webserver =
    { config, pkgs, ... }:
    { deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024; 
    };
}
