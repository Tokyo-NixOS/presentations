with import <nixpkgs> {};

(python2.buildEnv.override {
  extraLibs = with python2Packages;
  [ 
    # Used python2 packages
    # python2 packages can be listed with 
    # nix-env -f "<nixpkgs>" -qaP -A python2Packages
    numpy
  ];
}).env
