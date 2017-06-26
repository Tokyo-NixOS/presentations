{ stdenv, fetchurl, pythonPackages
# Number of epochs
, epochs ? 10
# Selecting backend
, backend ? "tensorflow"
/* TODO: add a parameter to control cuda usage
, cuda ? false
*/
}:

with stdenv.lib;

let

/*
  Our model data, could also be made to a separate derivation
  and passed as a dependency to this derivation
*/
data = fetchurl {
  url    =  https://s3.amazonaws.com/img-datasets/mnist.npz;
  sha256 = "1lbknqbzqs44qhnczv9a5bfdjl5qqgwgrgwgwk4609vm0b35l73k";
};

in stdenv.mkDerivation rec {
  name    = "model-${version}";
  version = "1";

  src  =  ./src/trainer;

  /* Model dependencies, adapted to the backed
  */
  nativeBuildInputs = with pythonPackages; [
    python
    Keras
    h5py
  ] ++ optionals (backend == "tensorflow") [
    pythonPackages.tensorflow
  ] ++ optionals (backend == "theano") [
    pythonPackages.Theano
  ];

  /* requiredSystemFeatures could be used to make
     the model leverage nix distributed builds

       requiredSystemFeatures = [ "big-parallel" "cuda" ];
  */

  /* environment variables used in the train script
  */
  EPOCHS = epochs;
  KERAS_BACKEND = backend;
  DATA = data;
  THEANO_FLAGS = "base_compiledir=$src";

  unpackPhase = ":";

  /* Training the model
  */
  buildPhase = ''
    python $src/train.py
  '';

  installPhase = ''
    mkdir -p $out
    cp model.h5 $out/
  '';
}
