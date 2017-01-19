/* Example of a derivation building an autoconf style C program

   The autoreconfHook build input automatically brings the needed packages and run the needed commands
*/

with import <nixpkgs> {};

stdenv.mkDerivation {

  name = "hello-world";

  src = ./src-3;

  # nativeBuildInputs are build time dependencies
  nativeBuildInputs = [ autoreconfHook ];

  # No need for a custom install phase, default install phase is enough

}
