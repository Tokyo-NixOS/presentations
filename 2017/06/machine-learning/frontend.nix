{ pythonPackages
, lib
, backend ? "tensorflow"
/* TODO: add a parameter to control cuda usage
, cuda ? false
*/
}:

with lib;

pythonPackages.buildPythonPackage rec {

  name = "cnn-mnist-${version}";
  version = "1.0";

  src = ./src/frontend;

  propagatedBuildInputs = with pythonPackages; [
    flask
    pillow
    scipy
    Keras
    h5py
  ] ++ optionals (backend == "tensorflow") [
    pythonPackages.tensorflow
  ] ++ optionals (backend == "theano") [
    pythonPackages.Theano
  ];

  /* Setting up the backend
  */
  postFixup = ''
    wrapProgram "$out/bin/cnn-mnist" \
      --set KERAS_BACKEND "${backend}"
  '';

}
