/* Test file for the binserver module
   Running this will start a clean virtual QEMU machine, run the test script and generate a report for us

     $ nix-build test.nix

   Report will be available in ./result

   ---

   binserver moduleのテスト
   このファイルを実行するとQEMUバーチャルマシンが起動し、テストが実行され、レポートが生成されます。

     $ nix-build test.nix

   ./resultにレポートが生成されます
*/

import <nixpkgs/nixos/tests/make-test.nix> ({ pkgs, ...} : {

  name = "binserver";

  /* Declaring test machines, it is possible to use multiple nodes 
     テストのマシンを宣言、複数マシンも使えます
  */
  nodes = { 
    server = { config, pkgs, ... }: { 
      /* importing the binser module
         binserverモジュールをインポート
      */
      imports = [ ./module.nix ];
      /* Enabling binserver module
         binserverモジュールを有効
      */
      services.binserver.enable = true;

      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx = {
        enable = true;
        config = ''
          events {}
          http {
            server {
              listen 80;
              location / {
                proxy_pass          http://127.0.0.1:8080;
                proxy_http_version  1.1;
              }
            }
          }
        '';
      };
    };
  };

  /* Test script, for more details see https://nixos.org/nixos/manual/index.html#sec-nixos-tests
     Tests are written in perl

     テストスクリプト、詳細は https://nixos.org/nixos/manual/index.html#sec-nixos-tests を参照
     テストはPerlで書かれています
  */
  testScript = ''
    startAll;
    $server->waitForUnit("nginx");
    $server->succeed('curl -s http://127.0.0.1/3 | grep "^11$"');
  '';
})
