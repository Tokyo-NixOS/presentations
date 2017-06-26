with import (fetchTarball https://github.com/nixos/nixpkgs/archive/ed070354a9.tar.gz) {};

rec {
  /* Model using default values (tensorflow backend, 10 epochs)
  */
  model = pkgs.callPackage ./model.nix {};

  /* Model using tensorflow backend with 1 epoch
  */
  simple-model = pkgs.callPackage ./model.nix {
    epochs = 1;
  };

  /* Model using theano backend with 3 epochs
  */
  custom-model = pkgs.callPackage ./model.nix {
    backend = "theano";
    epochs  = 3;
  };
  
  /* Frontend using default backend (tensorflow)
  */
  frontend = pkgs.callPackage ./frontend.nix {};

  /* Example of a customized frontend, using theano backend
  */
  frontend-theano = pkgs.callPackage ./frontend.nix {
    backend = theano;
  };
}
