{ pkgs ? import <nixpkgs> {} }:

with pkgs; dockerTools.buildImage {
  name = "redis"; 
  tag  = "latest"; 

  fromImageTag = "latest"; 

  contents = pkgs.redis; 
  runAsRoot = '' 
    #!${stdenv.shell}
    mkdir -p /data
  '';

  config = { 
    Cmd = [ "/bin/redis-server" ];
    WorkingDir = "/data";
    Volumes = {
      "/data" = {};
    };
  };
}
