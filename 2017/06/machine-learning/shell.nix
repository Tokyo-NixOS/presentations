with import /home/eric/Projects/nixos/nixpkgs {};

stdenv.mkDerivation {

  name = "cnn-mnist";
  buildInputs = [
    (python2Full.buildEnv.override { extraLibs = with pythonPackages; [ 
      Keras
      theano
      h5py
      scipy
      flask
      pillow
      numpy
      tensorflow
    ]; })
  ];
}
