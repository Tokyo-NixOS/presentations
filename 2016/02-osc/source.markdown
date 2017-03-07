% 関数型Linux: NixOSの仕組みと特徴の紹介
% OSC 2016 Tokyo/Spring
% 2016年2月26日

# 自己紹介

- サニエ エリック
- 東京NixOSミートアップオーガナイザー


# アジェンダ

- Nixパッケージマネージャーの紹介 (20分)
- NixOSリナックスの紹介 (10分)
- 東京NixOSミートアップの紹介 (5分)
- 質問タイム
- いつでも気軽に質問してください!


# パッケージマネージャーとは

- ファイル・プログラムをインストール・アップグレード・アンインストールをするソフトウェア
- 依存関係解決
- apt, yum, pacman
- パッケージ操作にリスクがあります
    - ルート権限が必要
- 依存管理は難しい
    - 依存地獄
    - パッケージの代わりにコンテナーでソフトウェア配布が最近増えてる


# Nix: 関数型パッケージマネージャー

- Eelco Dolstraの研究が原点
- 2006年に博士論文発表
- POSIX準拠 (LinuxとOS Xで利用できます)
- 主にC++で書かれている
- 良く出来た[マニュアル](http://nixos.org/nix/manual/)
- LGPLライセンス


# Nix: 特徴

- パッケージの複数バージョン
- 一般ユーザパッケージインストール
- パッケージカスタマイズ
- 依存関係完結の保証
- パッケージ完全隔離
- ソースビルドとバイナリインストール対応
- ビルド再現性の保証
- 並行ビルド
- 低リスク
- nix-shell


# Nix: 遅延評価純粋関数型パッケージマネジャー

- 関数型:
    - パッケージは関数であり、依存は引数
    - インストールされたパッケージのファイルは絶対に変更されない
    - → 安全性 (依存関係完結の保証、ロールバック)
- 純粋:
    - 関数の結果（パッケージ）は引数のみ（依存関係）で決まります
    - → 再現性
- 遅延評価
    - パッケージを簡単カスタマイズできます、パーフォーマンス向上
    - → 柔軟性


# Nix: 仕組み

- パッケージ"レシピ"関数（導出）
- パッケージレシピはNix言語で書かれています
- Nix言語はパッケージ用のドメイン固有言語
- NixはNix言語のコンパイラー
- パッケージはNixストアにインストールされます
- 導出コンパイル = パッケージのビルド + ストアへインストール


# Nix: 導出(パッケージレシピ)の例

- [シンプルな例](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix)
- [パッチの利用例](https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/archivers/cpio/default.nix)
- [複雑なパッケージ](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/http/apache-httpd/2.4.nix)


# Nix: Nixストア

- Nixはパッケージを必ずNixストアにインストールします
- ストア内に同じパッケージの複数バージョンが存在できます
- パッケージはストア内に導出ハッシュで特定されたフォルダーにインストールされます
- 隔離されたフォルダーにパッケージのすべてのファイルが入ります

    ~~~
    $ readlink $(which tree)
    /nix/store/zzljry2r5w14rmvg3p9lz7ym326rfcpp-tree-1.7.0/bin/tree

    $ tree /nix/store/zzljry2r5w14rmvg3p9lz7ym326rfcpp-tree-1.7.0/
    /nix/store/zzljry2r5w14rmvg3p9lz7ym326rfcpp-tree-1.7.0/
    ├── bin
    │   └── tree
    └── share
        └── man
            └── man1
                └── tree.1.gz
    ~~~

- パッケージは他のパッケージファイルを絶対に変更できない
- Nixストアは読み込み専用ファイルシステムでマウントされています


# Nix: 環境

- 特定なNixストアパッケージを環境にリンクする仕組み
- 環境は自動的にバージョニングされます
- 世代はコマンドでロールバックできます

    ~~~
    $ nix-env --list-generations
     28   2016-01-31 07:23:34
     29   2016-01-31 18:03:26   
     30   2016-02-06 11:58:46   
     31   2016-02-15 10:42:21   
     32   2016-02-15 10:44:14   (current)

    $ nix-env --switch-generation 30
    ~~~

# Nix: ソースとバイナリ

- パッケージでインストールされるファイルは導出で決まります（再現性）
- 導出のハッシュがわかれば、ストアフォルダーとインストールされるファイルを判別できます
- ハッシュを利用し、バイナリパッケージを特定できます
- 再現性を利用し、導出を評価せずにバイナリパッケージをインストールできます


# Nix: システムパッケージ以外の管理

- アプリケーションパッケージも対応（プログラミング言語）
- Haskellのサポートが特に進んでいる

    ~~~
    $ nix-env -f "<nixpkgs>" -qaP -A haskellPackages | wc -l
    12014
    ~~~

- Python等のパッケージもあります

    ~~~
    $ nix-env -f "<nixpkgs>" -qaP -A python2Packages | wc -l
    1199

    $ nix-env -f "<nixpkgs>" -qaP -A python33Packages | wc -l
    996

    $ nix-env -f "<nixpkgs>" -qaP -A python32Packages | wc -l
    997
    ~~~


# Nix: 万能ビルドシステム

- NixOSマニュアルの生成

    ~~~
    $ nix-build '<nixpkgs/nixos/release.nix>' -A manualPDF
    ~~~

- NixOS ISOイメージの生成

    ~~~
    $ nix-build '<nixpkgs/nixos/release.nix>' -A iso_minimal.x86_64-linux
    ~~~

- [テスト](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/boot.nix)の実行


# Nix: nix-shell

- インストールしてないプログラムのコマンド実行

    ~~~
    $ nix-shell -p jdk --run "java -version"
    ~~~

- 特定のパッケージを含めた一時環境

    ~~~
    $ nix-shell -p jdk -p subversion
    ~~~

    ~~~
    $ nix-shell -p jdk7 -p git --pure
    ~~~

- [開発環境用のnix-shellファイル](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/tree/master/nix-shells)


# Nix: 柔軟性

- パッケージのカスタマイズ(引数)

    ~~~
    libreNginx = nginx.override { openssl = libressl; }
    ~~~

- パッケージのカスタマイズ（パッケージオーバーライド）

    ~~~
    myNginx = nginx.overrideDerivation  (super:
      name = "nginx-git";
      src = fetchFromGitHub {
        sha256 = "04s7xcgmi5g58lirr48vf203n1jwdxf981x1p6ysbax24qwhs2kd";
        rev    = "c0eb2f0759726f47bd06f5c8f46739f43ce55cac";
        repo   = "nginx";
        owner  = "nginx";
      };
    })
    ~~~


# Nix: Devops向けパッケージマネジャー

- キーワード: 再現性、依存関係完結、パッケージ隔離
- closure: パッケージとその依存関係チェインのセット
- `nix-copy-closure`コマンドで他マシンにclosureをコピーできる

    ~~~
    $ nix-copy-closure --to alice@itchy.labs $(type -tp firefox)
    ~~~

    ~~~
    $ nix-copy-closure --from alice@itchy.labs /nix/store/0dj0503hjxy5mbwlafv1rsbdiyx1gkdy-subversion-1.4.4
    ~~~

- `nix-push`でNixストアclosureのバイナリキャッシュを生成できます

    ~~~
    $ nix-push --dest /tmp/cache $(nix-build -A thunderbird)
    ~~~

    - サーバを設定すれば、他のマシンからそのバイナリキャッシュは利用可能


# nixpkgs: パッケージレポジトリ

- Nixのパッケージレポジトリ
- [GitHubレポジトリ](https://github.com/NixOS/nixpkgs)
- パッケージ追加とアップデートはプールリクエスト
- 簡単に拡張
- 77000コミット以上
- 700コミッター以上
- ![](assets/nixpkgs-data-h.png)


# Hydra: ビルドファーム

- [Hydra](http://hydra.nixos.org/)はnixpkgsのビルドファーム
- 兼継続的インテグレーション(CI)
- 独自サーバにインストールできます
- [nixpkgsのジョブセット](http://hydra.nixos.org/jobset/nixpkgs/trunk)


# Nix: チャンネル

- チャンネルは特定な条件を満たすnixpkgsのバージョンを提供する仕組み
    - Hydraでビルドとテスト成功
- 種類はいくつかあります
    - 安定チャンネル、例 nixos-15.09
    - 不安定（開発）: nixos-unstable
    - サーバ向け、例 nixos-15.09-small, nixos-unstable-small
- Nixストア内にはチャンネルの最新nixpkgsが入っていて、Nixに利用されます
- Hydraでパッケージはビルドされているため、自動的にバイナリパッケージは生成されます


# Nix: パッケージインストール図

![](assets/nix-install-1.png)

# Nix: パッケージインストール図

![](assets/nix-install-2.png)

# Nix: パッケージインストール図

![](assets/nix-install-3.png)

# Nix: パッケージインストール図

![](assets/nix-install-4.png)


# Nix構造図

![](assets/nix-struct-global.png)


# Nix → NixOS

- 一息
- 質問？


# NixOS: 特徴

- 宣言型設定 (モジュールシステム)
- パッケージロールバック
- アトミックアップグレード
- 安定性
- 軽量コンテナー (systemd-nspawn利用)
- DevOps向けツール (NixOps)


# NixOS: OSとは？

- OS = パッケージ + 設定
- パッケージ = Nix
- 設定 = モジュールシステム
- NixOS = Nix + モジュールシステム

# NixOS: ロールバック

- コマンドでロールバック可能
- ブート画面でロールバック可能

    ![](assets/nixos-grub.png)


# NixOS: モジュールシステム

- 宣言型設定
- 自動化
- 拡張したNix言語を利用
    - OS設定固有ドメイン言語
    - [オプション型](https://nixos.org/nixos/options.html)
- 良く出来た[マニュアル](http://nixos.org/nixos/manual/)
- 独自モジュールで拡張可能
- /etc/nixos/configuration.nix がメインのファイルになります
- モジュールシステムはnixpkgsに含まれています


# NixOS: モジュールシステム例

- プロビジョニング

    ~~~nix
    environment.systemPackages = with pkgs; [
      firefox
      termite
      tmux
    ];
    ~~~

- systemdのサービス

    ~~~nix
    systemd.services.ircSession = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "forking";
        User = "username";
        ExecStart = ''${pkgs.tmux}/bin/tmux new-session -d -s irc -n irc ${pkgs.irssi}/bin/irssi'';
        ExecStop  = ''${pkgs.tmux}/bin/tmux kill-session -t irc'';
      };
    };
    ~~~

- gnomeを利用

    ~~~nix
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome3.enable = true;
    ~~~

- Apache HTTPDを有効

    ~~~nix
    services.httpd = {
      enable       = true;
      enablePHP    = true;
      adminAddr    = "web1@example.org";
      documentRoot = "/srv/http";
    };
    ~~~

- カーネルバージョンの変更

    ~~~nix
    boot.kernelPackages = pkgs.linuxPackages_4_4;
    ~~~

- ユーザ作成

    ~~~nix
    users.extraUsers.eric = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "scanner" "vboxusers" "audio" "docker" ];
      uid = 1000;
    };
    ~~~

- 日本語入力を有効

    ~~~nix
    i18n.inputMethod = {
      enabled  = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc anthy ];
    };
    ~~~

- firefoxのflashプラグインを有効

    ~~~nix
    nixpkgs.config = {
      allowUnfree = true;
      firefox.enableAdobeFlash = true;
    };
    ~~~

- フォント設定まで!

    ~~~nix
    fonts = {
      fonts = with pkgs; [ 
        ipafont
        powerline-fonts
        kochi-substitute
      ];
  
      fontconfig = { 
        defaultFonts = {
          monospace = [ 
            "DejaVu Sans Mono for Powerline"
            "IPAGothic"
          ];
          serif = [ 
            "DejaVu Serif"
            "IPAPMincho"
          ];
          sansSerif = [
            "DejaVu Sans"
            "IPAPGothic"
          ];
        };
      };
    };
    ~~~

- ループも利用できます

    ~~~nix
    services.httpd.virtualHosts =
      let
        makeVirtualHost = { name, root }:
          { hostName = name;
            documentRoot = root;
            adminAddr = "alice@example.org";
          };
      in map makeVirtualHost
        [ { name = "example.org"; root = "/sites/example.org"; }
          { name = "example.com"; root = "/sites/example.com"; }
          { name = "example.gov"; root = "/sites/example.gov"; }
          { name = "example.nl";  root = "/sites/example.nl"; }
        ];
    ~~~

- if分岐

    ~~~nix
    environment.systemPackages =
      if config.services.xserver.enable then
        with pkgs; [ firefox thunderbird ]
      else
        [ ];
    ~~~

# NixOS: 再構築

- nixos-rebuild コマンドで設定を適応する

    ~~~sh
    $ nixos-rebuild switch
    ~~~

- 設定をビルドのみ(コンパイルチェック)

    ~~~sh
    $ nixos-rebuild build
    ~~~

- 設定をビルドし、バーチャルマシン（QEMU）起動で動作確認

    ~~~sh
    $ nixos-rebuild build-vm
    ~~~


# NixOS: 再構築図

![](assets/nix-rebuild-1.png)

# NixOS: 再構築図

![](assets/nix-rebuild-2.png)

# NixOS: 再構築図

![](assets/nix-rebuild-3.png)

# NixOS: 再構築図

![](assets/nix-rebuild-4.png)


# NixOS: 再現性

- 宣言的にOSを設定できます
- configuration.nixを別マシンにコピーし、適応すれば同じ環境を再現できます
- [Surface 3](https://github.com/cransom/surface-pro-3-nixos)用のNixOS設定ファイルもあります


# NixOS: DevOps

- 専用ツール
- NixOps: NixOS環境のデプロイツール
    - nix言語で設定ファイル
    - バーチャルマシン、EC2、GCE、Hetznerなどをサポートします
    - 詳細は3月のNixOS勉強会へ!
- Disnix: サービス向けシステムデプロイツール
    - 異質OSネットワーク対応
    - ステートもサポート(Dysnomia)


# NixOS: 構造図

![](assets/nix-rebuild-global.png)


# NixOS → 日本コミュニティ

- 一息
- 質問？


# 東京NixOSミートアップ

- 2015年9月に始まった
- 毎月に勉強会をやります
- [Meetup](http://www.meetup.com/ja-JP/Tokyo-NixOS-Meetup/)と[Connpass](http://toikyo-nixos.connpass.com/)にグループあります
- 前回はパッケージ作成
- 次回は
    - 3月23日 19:00 - 21:00
    - テーマは[NixとDevOps、NixOps](http://toikyo-nixos.connpass.com/event/27671/)
    - 場所は[茅場町Co-Edo](https://www.coworking.tokyo.jp/)


# 活動

- GitHubで[日本語Wiki管理](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
- パッケージ追加、モジュール追加（日本語入力）
- マニュアル翻訳を近々に始める予定


# 最後に

- ブースに
    - NixOSを体験できるマシン
    - インストールCD
    - ステッカー
- があります、気軽に寄ってください!
- ご清聴ありがとうございました
- 質問タイム

