{
  hydra =
    { config, pkgs, ... }:
    { 
      deployment.targetEnv = "virtualbox";
      deployment.virtualbox.headless = true;
      deployment.virtualbox.memorySize = 4096;
    };
}
