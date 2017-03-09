/*
   binserverビルドファイル、buildPythonPackageは自動的にプロジェクトをビルドします
*/
{ lib, pythonPackages }:

pythonPackages.buildPythonPackage rec {

  name = "binserver-${version}";
  version = "2.0";
  propagatedBuildInputs = with pythonPackages; [ flask ];

  src = ./src;

}
