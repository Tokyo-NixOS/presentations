/*
  Nix shell file for the binserver project

  A nix shell file is similar to a derivation, but just need to know dependencies
  Extra dependencies can be added like editors or development tools

---

  binserプロジェクトのnix-shellファイル

  nix-shellファイルはビルドファイル（derivation）と似てるですが、依存関係だけが必要です。
  エディターやツールのような追加依存関係をつける事もできます。

*/
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation {
  name = "binserver-env";
  buildInputs = [
    # Project dependencies
    (pythonFull.withPackages (ps: with ps; [ flask ]))

    # utilities
    atom
    git
    tig
    qutebrowser
  ];
}
