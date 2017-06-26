with import /home/eric/Projects/nixos/nixpkgs {};

stdenv.mkDerivation {

  name = "cnn-mnist";
  buildInputs = [
    (python2full.buildenv.override { extralibs = with pythonpackages; [ 
      keras
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
