% Nixエコシステムの紹介 \
  〜パッケージ管理視点からDevOpsを考える〜
% サニエ エリック
% 2016年4月22日 @WUG

# 自己紹介

- サニエ エリック
- [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)オーガナイザー


# アジェンダ

1. パッケージマネージャーについて〜Nixの紹介〜
2. パッケージマネージャーからOSへ〜NixOSの紹介〜
3. DevOpsについて、NixからみたDevOps


# パッケージマネージャーについて〜Nixの紹介〜

# パッケージマネージャーとは

- ファイルやプログラムをインストール、アップグレードとアンインストールできるツール
- `apt`、`yum`、`pacman`、`portage`など
- 依存関係の解決
    - 依存干渉
- パッケージの代わりにDockerコンテナーでソフトウェア配布が増えてる


# Nix: 関数型パッケージマネージャー

- Eelco Dolstraの研究が原点
    - 2006年に[博士論文](http://nixos.org/~eelco/pubs/phd-thesis.pdf)発表
- POSIX準拠 (LinuxとOS Xで利用できます)
- 主にC++で書かれている
- LGPLライセンス


# Nix: 特徴

- **パッケージ**と**環境**を別に管理する
    - パッケージの複数バージョン
- 一般ユーザパッケージ操作
- ロールバック
- アトミックアップデート
- ソースビルドとバイナリインストール
- ビルドの再現性
- パッケージのカスタマイズ


# Nix: 仕組み

- Nix言語
    - パッケージ用のドメイン固有言語
- パッケージレシピはNix言語の関数 (derivation)
    - 依存関係は引数
- パッケージはNixストアにインストールされます
- Derivation評価 = パッケージのインストール
    - Nix(パッケージマネージャー)はNix言語のコンパイラーとも言える


# Nix: Derivation

- パッケージをビルドする関数（レシピ）
- 例
    - [hello](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix)
    - [httpd](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/http/apache-httpd/2.4.nix)


# Nix: Nixストア

- Derivationの結果はNixストアにインストールされます (`/nix/store/HASH-NAME-VERSION`)
- ストアフォルダー内にパッケージが完全隔離されています

    ~~~sh
    $ tree /nix/store/3j8jkah29zrksh5zz7dm9vbg2f3h37fx-tree-1.7.0/
    /nix/store/3j8jkah29zrksh5zz7dm9vbg2f3h37fx-tree-1.7.0/
    ├── bin
    │   └── tree
    └── share
        └── man
            └── man1
                └── tree.1.gz
    ~~~


# Nix: Nixストア

- パッケージのderivationハッシュが異なれば共存できる
- ストア内ファイルは不変（読み込みファイルシステムでマウント）
- ストア内の依存関係を確認できる

    ~~~sh
    $ nix-store -qR $(readlink $(which tmux))
    /nix/store/gygp4inn8w53wy161yy08ilf4kvzw0ki-linux-headers-3.18.14
    /nix/store/pv9sza1cf2kpawck7wbwdnhlip5h57lg-glibc-2.23
    /nix/store/idm1067y9i6m87crjqrbamdsq2ma5r7p-bash-4.3-p42
    /nix/store/frv0qy52hk6vv1fn6nh7m4grw7qxsydy-ncurses-5.9
    /nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r
    /nix/store/ignans7cvzxg4mg3qrm4f4ckb0y1dri9-attr-2.4.47
    /nix/store/awaqxik06wjw6rmckqlgd4ng94vawic9-acl-2.2.52
    /nix/store/95wmyhk0y60r09b98l6v4vswv5m7xm4q-coreutils-8.25
    /nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8
    /nix/store/ymjf7jwbg1xidafhksi9csqzfsb02zqx-bzip2-1.0.6
    /nix/store/awbf3jh262m1k16hxgbgngdmxv66gd79-python-2.7.11
    /nix/store/zhsp83fxdn39r7qmqqsd1hfdlw5vfh37-libevent-2.0.22
    /nix/store/7liaa6gl15h3wnhll731rnih7zb8fy15-tmux-2.1
    ~~~


# Nix: システムパッケージ以外の管理

- プログラミング言語パッケージ

    - Haskell

        ~~~sh
        $ nix-env -f "<nixpkgs>" -qaP -A haskellPackages | wc -l
        12524
        ~~~
    
    - Python
    
        ~~~sh
        $ nix-env -f "<nixpkgs>" -qaP -A python2Packages | wc -l
        1250
    
        $ nix-env -f "<nixpkgs>" -qaP -A python33Packages | wc -l
        1044
    
        $ nix-env -f "<nixpkgs>" -qaP -A python32Packages | wc -l
        1045
        ~~~


# Nix: 万能ビルドシステム

- マニュアルの生成

    ~~~sh
    $ nix-build '<nixpkgs/nixos/release.nix>' -A manualPDF
    ~~~

- ISOイメージの生成

    ~~~sh
    $ nix-build '<nixpkgs/nixos/release.nix>' -A iso_minimal.x86_64-linux
    ~~~


# Nix: 環境

- 一部のNixストアパッケージを合体する仕組み(シムリンク)
    - 自動バージョニング
- ロールバック可能

    ~~~sh
    $ nix-env --list-generations
     28   2016-01-31 07:23:34
     29   2016-01-31 18:03:26   
     30   2016-02-06 11:58:46   
     31   2016-02-15 10:42:21   
     32   2016-02-15 10:44:14   (current)

    $ nix-env --switch-generation 31
    ~~~


# Nix: ソースとバイナリ

- ソースビルドとバイナリ代替の透明利用
- 再現性で
    - derivationのハッシュでパッケージを特定できます
    - ハッシュでバイナリ代替を特定できます


# Nix: 柔軟性

- Derivationの引数

    ~~~nix
    libreNginx = nginx.override { openssl = libressl; }
    ~~~

- Derivationの属性

    ~~~nix
    myNginx = nginx.overrideDerivation  (super:
      name = "nginx-git";
      src = fetchFromGitHub {
        repo   = "nginx";
        owner  = "nginx";
        rev    = "c0eb2f0759726f47bd06f5c8f46739f43ce55cac";
        sha256 = "04s7xcgmi5g58lirr48vf203n1jwdxf981x1p6ysbax24qwhs2kd";
      };
    })
    ~~~


# nixpkgs: パッケージレポジトリ

- Nixの全パッケージレシピセット
- Gitレポジトリ、[GitHubで管理](https://github.com/NixOS/nixpkgs)
    - 80000コミット
    - 700コミッター
    - ![](assets/nixpkgs-data-h.png)


# Hydra: ビルドファーム

- [Hydra](http://hydra.nixos.org/)はnixpkgsのビルドファームシステム
- \+ 継続的インテグレーション(CI)
- パーソナルサーバにインストールできます
- [nixpkgsのジョブセット](http://hydra.nixos.org/jobset/nixpkgs/trunk)
- [ビルド詳細](https://hydra.nixos.org/build/33716430)


# Nix: チャンネル

- 特定な条件を満たすnixpkgsのバージョンを提供する仕組み
    - Hydraでビルドとテスト成功
- 3種類:
    - 安定チャンネル、例 `nixos-16.03`
    - 不安定（開発）: `nixos-unstable`
    - サーバ向け、例 `nixos-15.09-small`, `nixos-unstable-small`


# Nixまとめ

- `nixpkgs`: パッケージのレシピ集
- `hydra`: 定期的に`nixpkgs`を評価し、テスト実行とバイナリ生成するビルドファームシステム
- `nix`: パッケージマネージャー (Nix言語コンパイラー)
- 利点
    - 環境とパッケージを別に管理
    - 依存干渉解決
    - カスタマイズ性
    - 安全性


# Nix -> NixOS

- パッケージマネージャーからOSへ〜NixOSの紹介〜


# NixOS: 特徴

- 宣言型設定 (モジュールシステム)
- 安全性
    - ロールバック機能
    - アトミックアップグレード
- 軽量コンテナー


# NixOS: OSとは？

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


# NixOSまとめ

- 利点
    - 自動化
    - ロールバック・安全性
    - 柔軟性
    - 再現性


# NixOS -> DevOps

- DevOpsについて、NixからみたDevOps


# DevOpsとは

- Buzzword
- 定義は
    - デプロイメントから
    - 組織改善まで
- "シスアドミン版のアジャイル"
- 今日はソフトウェアデプロイメント改善と自動化の意味


# DevOpsが解決をする問題

- ソフトウェアを別マシンにリリースする
    - 環境の統一
    - 継続的インテグレーション(CI)、品質保証(QA)
- 簡単、早い、正しいデプロイメントを目指す


# 一般DevOpsツール

- 開発環境管理: [Vagrant](https://www.vagrantup.com/)
- 構成管理: [Chef](https://www.chef.io/chef/), [Ansible](https://www.ansible.com/), [Puppet](https://puppetlabs.com/)
- 仮想環境: [Docker](https://www.docker.com/)
- 継続インテグレーション: [Jenkins](https://jenkins-ci.org/), [Travis](https://travis-ci.org/)


# Nix: 誕生の秘密

- デプロイメントを解決するために開発された
- [nix論文](http://nixos.org/~eelco/pubs/phd-thesis.pdf)より(一行目)

    > This thesis is about getting computer programs from one machine to another - and having them still work when they get there.

    > この論文はプログラムをマシンから別マシンへ移し、正常動作を保つことを課題とします。


# NixのDevOpsスタック

- 開発環境管理: [nix-shell](http://nixos.org/nix/manual/#sec-nix-shell), [コンテナー](https://nixos.org/nixos/manual/index.html#ch-containers)
- 構成管理: [NixOps](https://nixos.org/nixops/), [DisNix](https://nixos.org/disnix/)
- 仮想環境: [コンテナー](https://nixos.org/nixos/manual/index.html#ch-containers)、[NixOps](https://nixos.org/nixops/)
- 継続インテグレーション: [Hydra](https://nixos.org/hydra/)


# 開発環境管理: nix-shell

- 一時的な環境を起動するツール
- `nix-shell`を試す

    ~~~
    $ nix-shell -p redis --run "redis-server"
    ~~~

    ~~~
    $ nix-shell -p redis --run "redis-cli"
    ~~~

- nixファイルで定義した環境を読み込める
    - Python開発用nix-shell 

        ~~~
        examples/nix-shell/python.nix
        ~~~


# 開発環境管理: コンテナー

- [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)ベース
- Web開発に向いてる
- `configuration.nix`で宣言
- Vagrantと似た使い方ができます
- `configuration.nix`と同じオプションを利用できます
    - \+ ネットワーク定義 (`hostAddress`, `localAddress`)
    - \+ シェアフォルダー (`bindMounts`)


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


# パッケージのコピー

- クロージャー: パッケージとランタイム依存のセット
- `nix-store`コマンドでクロージャーを確認
    
    ~~~sh
    $ nix-store -qR STORE-PATH
    ~~~

- `nix-copy-closure`でクロージャーをssh経由で他マシンへコピーできる

    ~~~sh
    $ nix-copy-closure --to   USER@SERVER STORE-PATH
    ~~~

    ~~~sh
    $ nix-copy-closure --from USER@SERVER STORE-PATH
    ~~~


# カスタムパッケージのデプロイ

- pythonアプリケーション

    ~~~
    examples/package/
    ~~~


# NixOps

- NixOSデプロイメントの自動化ツール
- コマンドラインツール: `nixops`
- 論理ネットワークと物理ネットワークを別々に管理
- Amazon EC2, Google CEなどのサービスと一般サーバを対応


# NixOpsで独自パッケージをデプロイ

- [pythonアプリケーション](https://github.com/ericsagnes/binry)

    ~~~
    examples/nixops/package/
    ~~~


# NixOpsで独自モジュールをデプロイ

- [python webサービス](https://github.com/ericsagnes/binserver)

    ~~~
    examples/nixops/module/
    ~~~


# NixOps + コンテナーで独自モジュールをデプロイ

- [python webサービス](https://github.com/ericsagnes/binserver)

    ~~~
    examples/nixops/module+container/
    ~~~


# NixOps例

- [Nixホームページ](https://github.com/NixOS/nixops/blob/master/examples/nix-homepage.nix)
- [Hydra](https://github.com/peti/hydra-tutorial)
- [NixPaste](http://nixpaste.lbr.uno/) [github](https://github.com/lethalman/nixpaste)


# DisNix

- [DisNix](https://nixos.org/disnix/)はNixを利用して、(マイクロ)サービスのデプロイメントツール(異質環境対応)
- [例](https://github.com/svanderburg/disnix-stafftracker-java-example)


# DockerとNix

- `dockerTools`で軽量dockerイメージを生成できます
- Redisを含めたイメージを生成

    ~~~
    examples/docker/
    ~~~

    ~~~sh
    $ nix-build docker.nix
    $ docker load < NIX-STORE-PATH
    $ docker run redis redis-cli --version
    ~~~


# まとめ

- DevOpsはパッケージマネジメントの短所を解決
- NixでDevOpsスタックを統一できます


# おわり

- ご清聴ありがとうございました！
- 毎月勉強会をやります、お気軽に参加ください
- 質問？
- 関連リンク

    * [公式サイト](http://nixos.org/)
    * [Nixマニュアル](http://nixos.org/nix/manual/) (英語)
    * [NixOSマニュアル](http://nixos.org/nixos/manual/) (英語)
    * [nixpkgsマニュアル](http://nixos.org/nixpkgs/manual/) (英語)
    * [NixOpsマニュアル](https://nixos.org/nixops/manual/) (英語)
    * [日本語Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
    * [過去勉強会資料](https://github.com/Tokyo-NixOS/presentations)
    * [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)

