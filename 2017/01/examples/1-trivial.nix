/* Example of a nix expression to generate an empty package
*/

# Importing nixpkgs so we can use stdenv
with import <nixpkgs> {};

stdenv.mkDerivation {

  name = "trivial";

  # skipping the unpack phase
  unpackPhase = ":";

  installPhase = ''
    # just creating the package output directory in the nix store
    mkdir $out
  '';

}
