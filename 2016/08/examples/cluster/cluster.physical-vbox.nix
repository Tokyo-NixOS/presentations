let 
  # Hekper function to generate a vbox config
  generateVboxConfig = memory:
    { config, pkgs, ... }:
    {
      deployment.targetEnv = "virtualbox";
      deployment.virtualbox.headless = true;
      deployment.virtualbox.memorySize = memory;
    };
in
{
  master = generateVboxConfig 1024;
  slave1 = generateVboxConfig 4096;
  slave2 = generateVboxConfig 4096;
}
