/* 

  binserverのビルドファイル、nixpkgsと連携取りやすいようにcallPackageを利用します

  決定性を上げるため、利用するnixpkgsのバージョンを特定できます。チャンネルとコミットが使えます。

    { pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-16.09.tar.gz) {} }:
    { pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz) {} }:
    { pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs/58d44a3.tar.gz) {} }:

*/
{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./derivation.nix {}
