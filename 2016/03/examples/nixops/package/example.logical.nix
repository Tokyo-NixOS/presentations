{
  network.description = "NixOps package example";

  webserver = { config, pkgs, ... }:
    let
      # 外部パッケージの宣言
      binrySrc = (import <nixpkgs> {}).fetchFromGitHub {
          owner  = "ericsagnes";
          repo   = "binry";
          rev    = "v1.0";
          sha256 = "073qrnlr5jwaha9ynlrsrfqf123mwnzwg08w16rw614dlpq7jkrf";
      };
    in
    { 
      # パッケージプロビジョニング
      environment.systemPackages = [
        (import "${binrySrc}/release.nix" {})
      ];

    };
}
