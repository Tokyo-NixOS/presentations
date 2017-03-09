/*

  binserverプロジェクトのnix-shellファイル

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
    http-prompt
  ];
}
