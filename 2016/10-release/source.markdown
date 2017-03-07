% NixOS 16.09 Release
% サニエ エリック
% 2016年10月13日 - Tokyo NixOS Meetup


# 自己紹介

- サニエエリック
- 東京NixOSミートアップオーガナイザー
- NixOSコントリビューター（インプットメソッド等）
- 今は遊びでNixベースのスタティックサイトジェネレーターを作ってます


# NixOS

> The Purely Functional Linux Distribution


# Project OverView

- [コントリビューションレートはGitHubのTop 10以内](http://krihelinator.xyz/)
- [レビューアー数はGitHubの6位](https://octoverse.github.com/)
- ~9万コミット
- ~900コントリビューター
- Nixパッケージマネジャーベース
- ![](assets/nixpkgs-data-h.png)


# 概要

- 完全オリジナル
- Nixパッケージマネージャーベース
- 2006年誕生


# NixOS: 特徴

- 宣言型設定 (モジュールシステム)
- 安全性
    - ロールバック機能
    - アトミックアップグレード
- 軽量コンテナー
- DevOps


# NixOS: OSとは?

- OS = パッケージ + 設定
    - パッケージ = Nix
    - 設定 = モジュールシステム
- NixOS = Nix + モジュールシステム


# NixOS: モジュールシステム

- 宣言型設定
- プロビジョニング、サービス、ブート、ファイルシステム…
- 3500個以上の[オプション](http://nixos.org/nixos/options.html)
- Nix言語を利用
- 独自モジュールで拡張可能
- `/etc/nixos/configuration.nix`がメインの設定ファイル


# NixOS: モジュールシステム例

- プロビジョニング

    ~~~nix
    environment.systemPackages = with pkgs; [
      git
      mutt
      tmux
    ];
    ~~~

- sytemdサービス

    ~~~nix
    systemd.services.ircSession = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      serviceConfig = {
        Type      = "forking";
        User      = "username";
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s irc -n irc ${pkgs.irssi}/bin/irssi";
        ExecStop  = "${pkgs.tmux}/bin/tmux kill-session -t irc";
      };
    };
    ~~~


# NixOS: モジュールシステム例

- デスクトップ環境

    ~~~nix
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome3.enable = true;
    ~~~

- カーネルバージョンの指定

    ~~~nix
    boot.kernelPackages = pkgs.linuxPackages_4_4;
    ~~~

- ユーザ作成

    ~~~nix
    users.extraUsers.foo = {
      isNormalUser = true;
      extraGroups  = [ "wheel" ];
    };
    ~~~


# NixOS: モジュールシステム例

- httpdを有効

    ~~~nix
    services.httpd = {
      enable       = true;
      enablePHP    = true;
      adminAddr    = "alice@example.org";
      documentRoot = "/srv/http";
    };
    ~~~

- Nix言語も活かせる

    ~~~nix
    services.httpd.virtualHosts =
      let
        makeVirtualHost = { name, root }:
          { hostName     = name;
            documentRoot = root;
            adminAddr    = "alice@example.org"; };
      in map makeVirtualHost
        [ { name = "example.org"; root = "/sites/example.org"; }
          { name = "example.com"; root = "/sites/example.com"; }
          { name = "example.gov"; root = "/sites/example.gov"; }
          { name = "example.nl";  root = "/sites/example.nl";  } ];
    ~~~


# NixOS: モジュールシステム例

- `if`

    ~~~nix
    environment.systemPackages = with pkgs;
      if config.services.xserver.enable then
        [ firefox thunderbird ]
      else
        [ elinks mutt ];
    ~~~

- gitlabを有効

    ~~~nix
    services.gitlab = {
      enable = true;
      databasePassword = "eXaMpl3";
      initialRootPassword = "UseNixOS!";
      https = true;
      host  = "git.example.com";
      port  = 443;
      user  = "git";
      group = "git";
      extraConfig = {
        gitlab = {
          default_projects_features = { builds = false; };
        };
      };
    };
    ~~~


# NixOS: 再構築

- `nixos-rebuild`コマンドで設定を適応する

    ~~~sh
    $ nixos-rebuild switch
    ~~~

- 設定をビルドし、バーチャルマシン（QEMU）で動作確認

    ~~~sh
    $ nixos-rebuild build-vm
    ~~~

- パッケージセットと設定ファイルを指定できます

    ~~~sh
    $ nixos-rebuild build-vm -I nixpkgs=~/my-project/nixpkgs/ -I nixos-config=~/my-project/configuration.nix
    ~~~


# NixOS: ロールバック

- コマンドでロールバック可能
- ブート画面でロールバック可能

    ![](assets/nixos-grub.png)


# NixOS: 再現性

- 宣言的にOSを定義できます
- 設定ファイルを別マシンにコピーするだけで同じ環境を再現できます
    - [Surface 3](https://github.com/cransom/surface-pro-3-nixos)用のNixOS設定ファイル


# NixOS 16.09 ハイライト

- セキュリティ: コンパイラ (Hardening Flags)
- 使用ディスク容量減少 (Multiple outputs)
- PXEネットブート対応
- 50以上の新モジュール
