/* Example of a derivation building a trivial bash executable

   Note the shebang path is replaced with the full store path
*/

with import <nixpkgs> {};

stdenv.mkDerivation {

  name = "hello-bash";

  # getting source files from a local directory
  src = ./src-2;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/helloworld $out/bin/
    chmod +x $out/bin/helloworld
  '';

}
