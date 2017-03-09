% NixOSの基本 ― 開発と運用管理に特化したLinuxの紹介 ―
% サニエ エリック
% 2017年3月10日 - オープンソースカンファレンス <br/><br/> [https://github.com/Tokyo-NixOS/presentations](https://github.com/Tokyo-NixOS/presentations) <br/><br/>Google: NixOS プレゼンテーション

# 自己紹介

- サニエ エリック
- [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)オーガナイザー
- [NixOS](http://nixos.org/)コントリビューター


# NixOSとは

- Linuxディストリビューション
- サーバ・デスクトップ対応
- 完全オリジナル
- 2006年、[博士論文](http://nixos.org/~eelco/pubs/phd-thesis.pdf)から誕生


# NixOSでできる事

- 開発環境の管理
- コンテナー
- プロビジョニング・構成管理
- 運用管理
- 継続インテグレーション


# NixOSの特徴

1. モジュールシステム
2. パッケージマネジャー


# モジュールシステム

- システムレベルのドットファイル
- 一つの設定ファイルでOSを完全管理できる
- 専用ドメイン固有言語の利用(Nix言語)


# モジュールシステムの例

- プロビジョニング

    ```nix
    environment.systemPackages = with pkgs; [
      firefox
      git
      libreoffice
      pidgin
    ];
    ```

- デスクトップマネジャー選択

    ```nix
    services = {
      xserver = {
        enable = true;
        layout = "jp";
        displayManager.gdm.enable = true;
        desktopManager.gnome3.enable = true;
      };
    };
    ```

# モジュールシステムの例

- nginxの設定

    ```nix
    services.nginx = {
      enable = true;
      httpConfig = ''
        server {
          listen 80;
          server_name mydomain.org;
          location / {
            root ${pkgs.valgrind.doc}/share/doc/valgrind/html
          }
        }
      '';
    };
    ```

# モジュールシステムの例

- データベースの設定

    ```nix
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql94;
      initialScript = ./schema.sql;
      extraConfig = ''
        max_connections = 100
        shared_buffers = 1GB
      '';
    };
    ```


# モジュールシステムの例

- systemdサービス

    ```nix
    systemd.user = { 

      services = {
        mbsync = {
          serviceConfig.Type = "oneshot";
          description = "mailbox sync";
          after       = [ "network-online.target" ];
          wantedBy    = [ "default.target" ];
          serviceConfig.ExecStart = "${pkgs.isync}/bin/mbsync -a";
        };
      };

      timers = {
        mbsync = {
          timerConfig = {
            OnCalendar= "*:0/5";
            Persistent = "true";
          };
          wantedBy = [ "timers.target" ];
        };
      };

    };
    ```


# モジュールシステムの例

- カーネルバージョン指定

    ```nix
    boot.kernelPackages = pkgs.linuxPackages_4_10;
    ```

- ファイヤーウォール設定

    ```nix
    networking.firewall.allowedTCPPorts = [ 80 ];
    ```
- sudo

    ```nix
    security.sudo.enable = true;
    ```
- ユーザ管理

    ```
    users.extraUsers.foo = {
      isNormalUser = true;
      extraGroups = [ "wheel" "vboxusers" "audio" "docker" ];
    };
    ```


# モジュールシステムの例

- コンテナー

    ```nix
    containers.nginx = {
      privateNetwork = true;
      hostAddress    = "10.0.0.11";
      localAddress   = "10.0.0.12";
  
      config = { config, pkgs, ... }: { 
        networking.firewall.allowedTCPPorts = [ 80 ];
  
        services.nginx = {
          enable = true;
          httpConfig = ''
            server {
              listen 80;
              location / {
                root ${pkgs.valgrind.doc}/share/doc/valgrind/html
              }
            }
          '';
        };
      };

    };
    ```


# モジュールシステムの例

- カスタムモジュール

    ```nix
    imports = [
      /path/to/my/module.nix
    ];

    services.my-service.enable = true;
    ```


# モジュールシステム

- 設定反映は`nixos-rebuild`コマンド実行
    - `nixos-rebuild build-vm`でバーチャルマシンで設定をテストできる
- 設定変更の履歴は残り、ロールバック可能

    ![](assets/nixos-grub.png)



# モジュールシステムのメリット

- 構成の移行、保存、共有と復元
- オプションのタイプチェック、間違った設定は反映できない

    ```nix
    security.sudo.enable = "true";
    ```

    ```sh
    $ nixos-rebuild build
    building Nix...
    building the system configuration...
    error: The option value `security.sudo.enable' in `/etc/nixos/configuration.nix' is not a bool.
    ```

- Nix言語にはロジックが使える（ループ、分岐、...）
- どの変更も簡単にロールバック可能
- カスタムモジュールは簡単に追加と利用


# パッケージシステム

- [Nixパッケージマネジャー](http://nixos.org/nix)
- 独特な機能
    - 環境管理: パッケージ != 環境
    - 複数バージョンの同時インストール
    - 一般ユーザインストール
    - ユーザ毎にパッケージ利用可能
    - ソースコンパイルとバイナリインストール
    - アトミックアップグレード
    - 他リナックス、OSX、Bash on Ubuntu on Windowsでも利用可能


# パッケージマネジャーを超えて

- Nixは汎用的なビルドシステム
- ビルドの**決定性**と**再現性**
- ビルドレシピはNix言語で書かれている（モジュールと同様）


# ビルドシステム

- 独自パッケージ作成、インストール、削除は簡単
- デモ: `2017/03-osc/examples/binserver/derivation.nix`


# Nixのメリット

- 汎用性:何でもビルドできます
    - Python, Ruby, NodeJSなどパッケージ
    - [この資料](https://github.com/Tokyo-NixOS/presentations)
    - [静的ウェブサイト](https://github.com/styx-static/styx)
    - [Dockerイメージ](https://nixos.org/nixpkgs/manual/#sec-pkgs-dockerTools)
    - [アンドロイドアプリケーション](http://sandervanderburg.blogspot.jp/2012/11/building-android-applications-with-nix.html)
    - ISOファイル
    - テスト
- ビルドの再現性
- 完全な依存関係
- パッケージの簡単デプロイ


# 開発環境の管理

- `nix-shell`コマンドで一時的な環境を起動できます
- デモ: `2017/03-osc/examples/binserver/shell.nix`


# 運用管理ツール

- [NixOps](https://nixos.org/nixops/): NixOS構成の運用管理ツール
    - 再現性
    - カスタムパッケージのデプロイ
    - クラスター対応
- [DisNix](https://nixos.org/disnix): サービス・マイクロサービス運用管理ツール
    - 異質環境対応


# 継続インテグレーション

- [Hydra](https://nixos.org/hydra/): Nixベースの継続インテグレーションサーバ
    - 複数アーキテクチャ対応
    - クラスター対応
    - カスタムビルドプロダクト
    - バーチャルマシンでのテスト実行
    - 簡単に自サーバへインストール可能
    - [例:nixpkgs Hydra](http://hydra.nixos.org/jobset/nixpkgs/trunk)


# NixOSのメリット

- 技術の統一性と一貫性
- ビルドとデプロイの再現性と決定性
- 簡単なデプロイ
- 簡単なカスタマイズ
- 安全性: ロールバック


# リンク

- [公式サイト](http://nixos.org/)
- [NixOSマニュアル](http://nixos.org/nixos/manual/) (英語)
- [NixOpsマニュアル](https://nixos.org/nixops/manual/) (英語)
- [日本語Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
- [過去勉強会資料](https://github.com/Tokyo-NixOS/presentations) https://github.com/Tokyo-NixOS/presentations
- [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)
