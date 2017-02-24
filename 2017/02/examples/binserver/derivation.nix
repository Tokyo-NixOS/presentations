/*
   binserver build file (derivation), buildPythonPackage does all the magic for us

   ---

   binserverビルドファイル、buildPythonPackageは自動的にプロジェクトをビルドします
*/
{ lib, pythonPackages }:

pythonPackages.buildPythonPackage rec {

  name = "binserver-${version}";
  version = "2.0";
  propagatedBuildInputs = with pythonPackages; [ flask ];

  src = ./src;

  meta = {
    description = "server converting decimal to binary";
    maintainers = with lib.maintainers; [ ericsagnes ];
  };

}
