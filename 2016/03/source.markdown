% NixOps & Nix DevOps
% Tokyo NixOS Meetup
% 2016年3月24日

# This month in Nix - [News from the front](https://github.com/NixOS/nixpkgs)

- NixOS 16.03 β
- [fcitx input method do not work on unstable and 16.03](https://github.com/NixOS/nixpkgs/issues/14019)
- [NixUP](https://github.com/NixOS/nixpkgs/pull/9250)
- [nixos-assimilate](https://github.com/NixOS/nixpkgs/issues/2079)
- [Multiple Output](https://github.com/NixOS/nixpkgs/pull/7701)テスト段階、16.09にマージ予定
- [コンテナー改善](https://github.com/NixOS/nixpkgs/pull/3021)


# This month in Nix - [Reddit topics](https://www.reddit.com/r/NixOS/)

- Erlang Factory 2016で2つのNix関連トークがありました
    - [Erlang On NixOS - Managing And Releasing Erlang Systems In The Cloud With A Fully Declarative Package Manager](https://www.youtube.com/watch?v=xRSFJH3Lw6I)
    - [From Zero To Production](https://www.youtube.com/watch?v=5vVZzu6HMaQ)
- [Practical use of NixOS/nixpkgs](https://www.youtube.com/watch?v=f89d1YCsJ2I)


# This month in Nix - [ML topics](http://news.gmane.org/gmane.linux.distributions.nixos)

- [IED, an alternate package manager for node](http://article.gmane.org/gmane.linux.distributions.nixos/19941)
- [Overriding by removing a derivation attribute](http://article.gmane.org/gmane.linux.distributions.nixos/19789)
- [Displaying package parameters](http://article.gmane.org/gmane.linux.distributions.nixos/19714)


# This month in Nix - [Tokyo NixOS](https://github.com/Tokyo-NixOS/)

- OSC東京
    - [トーク](https://github.com/Tokyo-NixOS/presentations)
    - グッズ
- マニュアル翻訳開始
- [勉強会資料](https://github.com/Tokyo-NixOS/presentations)生成をmakeからnixに変更
- 4月22日に[Wakame User Group](http://axsh.jp/community/wakame-users-group.html)にNixを紹介します


# DevOpsとは

- Buzzword
- デプロイメントから
- 組織改善まで
- "シスアドミン版のアジャイル"
- 今日はソフトウェアデプロイメント改善と自動化を中心とします


# DevOpsが解決をする問題

- 問題のないソフトウェアをリリースする
    - 環境の統一
    - 継続的インテグレーション(CI)、品質保証(QA)
- 簡単、早い、正しいデプロイメント
    - 専用ツール
- リリース反復↑、品質↑、リスク↓、効率↑


# DevOpsツール

- 開発環境管理: [Vagrant](https://www.vagrantup.com/)
- 構成管理: [Chef](https://www.chef.io/chef/), [Ansible](https://www.ansible.com/), [Puppet](https://puppetlabs.com/)
- 仮想環境: [Docker](https://www.docker.com/)
- 継続インテグレーション: [Jenkins](https://jenkins-ci.org/), [Travis](https://travis-ci.org/)


# Nix特徴

- 環境とパッケージを別々に管理
- 依存地獄解決
- 設計でDevOps問題を部分的に解決
- 元々デプロイメントを解決するために開発された
- [nix論文](http://nixos.org/~eelco/pubs/phd-thesis.pdf)より

    > This thesis is about getting computer programs from one machine to another - and having them still work when they get there.


# NixのDevOpsスタック

- 開発環境管理: [nix-shell](http://nixos.org/nix/manual/#sec-nix-shell), [コンテナー](https://nixos.org/nixos/manual/index.html#ch-containers)
- 構成管理: [NixOS](https://nixos.org/), [NixOps](https://nixos.org/nixops/), [DisNix](https://nixos.org/disnix/)
- 仮想環境: コンテナー、[NixOps](https://nixos.org/nixops/)
- 継続インテグレーション: [Hydra](https://nixos.org/hydra/)


# 開発環境管理: nix-shell

- 特定な環境を起動するツール
- `nix-shell`を試す

    ~~~sh
    $ nix-shell -p redis --run "redis-server"
    ~~~

    ~~~sh
    $ nix-shell -p redis --run "redis-cli"
    ~~~

- nixファイルで定義した環境を読み込める
- デモ: python開発用nix-shell 

    ~~~sh
    examples/nix-shell/python.nix
    ~~~

- デモ: haskell開発用nix-shell

    ~~~sh
    examples/nix-shell/haskell.nix
    ~~~

# nix-shell tips

- `-I nixpkgs=`パラメーターで特定なnixpkgsバージョンを利用できます
- `--pure`で純粋な環境を利用
- hookも利用できます


# 開発環境管理: コンテナー

- [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)ベース
- Web開発に向いてる
- configuration.nixで宣言
- Vagrantと似た使い方ができます
- `configuration.nix`と同じオプションを利用できます
- ネットワーク定義 (`hostAddress`, `localAddress`)
- シェアフォルダー (`bindMounts`)


# 開発環境管理: コンテナー

- サンプル

    ~~~nix
    containers.httpd = {
  
      privateNetwork = true;
      hostAddress    = "10.0.0.11";
      localAddress   = "10.0.0.12";
      autoStart      = true;
  
      config = { config, pkgs, ... }: { 
  
        # ポート開放
        networking.firewall.allowedTCPPorts = [ 80 ];

        # アパッチhttpdを有効
        services.httpd = {
          enable       = true;
          adminAddr    = "alice@example.org";
          documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
        };

      };
    };
    ~~~

- `container@CONTAINER-NAME.service`ユニットで管理される
- コンテナーにログインできます

    ~~~sh
    $ nixos-container login CONTAINER-NAME
    ~~~

    ~~~sh
    $ nixos-container root-login CONTAINER-NAME
    ~~~


# ソフトウェアをパッケージ

- Nixファイルでパッケージを定義
- `nix-build`でパッケージビルド
- `nix-copy-closure`でクロージャを他マシンにコピー
- `nix-env`で環境にインストール


# クロージャー

- パッケージとランタイム依存のセット
- ストアパースに対して、クロージャーを`nix-store`コマンドで確認できます
    
    ~~~sh
    $ nix-store -qR STORE-PATH
    ~~~

- `--graph`パラメーターでクロージャーのdotファイルを生成できます

    ~~~sh
    $ nix-store -q --graph STORE-PATH > CLOSURE.dot
    ~~~

    ~~~sh
    $ nix-shell -p python27Packages.xdot --run "xdot CLOSURE.dot"
    ~~~

- `nix-copy-closure`でクロージャーを他マシンに移動できます

    ~~~sh
    $ nix-copy-closure --to USER@SERVER STORE-PATH
    ~~~

    ~~~sh
    $ nix-copy-closure --from USER@SERVER STORE-PATH
    ~~~

- `nix-env -i`でパッケージをインストールできます

    ~~~sh
    $ nix-env -i STORE-PATH
    ~~~


# カスタムパッケージのデプロイ

- デモ: [pythonアプリケーション](https://github.com/ericsagnes/binry)

    ~~~
    examples/package/
    ~~~


# NixOps

- NixOSデプロイメントを自動化
- コマンドラインツール: `nixops`
- 論理ネットワークと物理ネットワークを別々に管理
- `sqlite`を利用(`~/.nixops/deployments`)
- Amazon EC2, Google CE、一般サーバ等のサポート

# NixOps利用流れ

- デプロイメントを作成

    ~~~sh
    $ nixops create LOGICAL.nix PHYSICAL.nix -d DEPLOYMENT
    ~~~

- デプロイメントをリストアップ

    ~~~sh
    $ nixops list
    ~~~

- デプロイメントの情報確認

    ~~~sh
    $ nixops info -d DEPLOYMENT
    ~~~

- デプロイメントを展開

    ~~~
    $ nixops deploy -d DEPLOYMENT
    ~~~

- マシンに接続

    ~~~
    $ nixops ssh -d DEPLOYMENT MACHINE
    ~~~


# NixOpsで独自パッケージをデプロイ

- デモ: [pythonアプリケーション](https://github.com/ericsagnes/binry)

    ~~~
    examples/nixops/package/
    ~~~


# NixOpsで独自モジュールをデプロイ

- モジュール例: [binserver](https://github.com/ericsagnes/binserver)の紹介
- デモ: python webサービス

    ~~~
    examples/nixops/module/
    ~~~


# NixOps + コンテナーで独自モジュールをデプロイ

- デモ: python webサービス

    ~~~
    examples/nixops/module+container/
    ~~~


# NixOps: noneバックエンド

- `none`バックエンドは普通のサーバをターゲットします
- サーバにNixOSインストールが必要
- 参考ファイル 

    ~~~
    examples/nixops/none/
    ~~~

# NixOps例

- [mediawiki](https://github.com/NixOS/nixops/blob/master/examples/mediawiki.nix)
- [Nixホームページ](https://github.com/NixOS/nixops/blob/master/examples/nix-homepage.nix)
- [Hydra](https://github.com/peti/hydra-tutorial)
- [NixPaste](https://github.com/lethalman/nixpaste)

# NixOps Tips

- 論理定義ファイルを`NAME.logical.nix`、物理定義ファイルを`NAME.physical.nix`にするとわかりやすい

- `-I nixpkgs=`パラメーターで各コマンドに特定なチャンネルを利用できる

    ~~~sh
    $ nixops deploy -d DEPLOYMENT -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-15.09-small.tar.gz
    ~~~

    ~~~sh
    $ nixops deploy -d DEPLOYMENT -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable-small.tar.gz
    ~~~

    ~~~sh
    $ nixops deploy -d DEPLOYMENT -I nixpkgs=/home/foo/nixpkgs/
    ~~~

- json形式でデプロイメントのインポート・エクスポートできます

    ~~~sh
    $ nixops export -d DEPLOYMENT > FILE.json
    ~~~

    ~~~sh
    $ nixops import -s DEPLOYMENT < FILE.json
    ~~~

- パラメーターを設定する事ができます

    ~~~sh
    $ nixops set-args --arg active true
    ~~~

- デプロイメントは変更できます

    ~~~sh
    $ nixops modify -d DEPLOYMENT -n NEWNAME LOGICAL.nix PHYSICAL.nix
    ~~~


# DisNix

- [DisNix](https://nixos.org/disnix/)はNixを利用して、サービスの自動デプロイメントツール(異質環境対応)
- DisNix
    - サービスモデル: サービスとその依存関係定義
    - インフラモデル: 物理ネットワーク定義
    - デプロイメントモデル: サービスをインフラのマップ定義
- [例](https://github.com/svanderburg/disnix-stafftracker-java-example)


# DisNixとNixOps

- NixOpsはNixOSの自動デプロイメントツール
- DisNixはNixベースのサービスデプロイメントツール


# DockerとNix

- `dockerTools`でdockerイメージを生成できます
- デモ: redisを含めたイメージを生成

    ~~~
    examples/docker/
    ~~~

    ~~~sh
    $ docker load < NIX-STORE
    $ docker run IMAGE COMMAND 
    ~~~


# リンク

* [NixOpsマニュアル](https://nixos.org/nixops/manual/) (英語)
* [日本語Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
* [NixOSマニュアル](http://nixos.org/nixos/manual/) (英語)
* [パッケージ検索](http://nixos.org/nixos/packages.html) (英語)
* [モジュールオプション検索](http://nixos.org/nixos/packages.html) (英語)
* [Contributor Guide](http://nixos.org/nixpkgs/manual/) (英語)
