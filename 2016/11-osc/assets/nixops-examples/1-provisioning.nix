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

    environment.systemPackages = with pkgs; [
      git
      tree
    ];

  };
}
