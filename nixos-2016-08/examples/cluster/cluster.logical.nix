{

  network.description = "Hydra Cluster Example";

  master = import ./machine.master.nix;

  slave1 = import ./machine.slave.nix;
  slave2 = import ./machine.slave.nix;

}
