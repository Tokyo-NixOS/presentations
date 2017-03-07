% Hydra
% サニエ エリック
% 2016年8月10日 - Tokyo NixOS Meetup


# アジェンダ

- ニュース
- Hydra

# ニュース


# This month in Nix - News from the front 1/2

- [Deploying a NixOS VM on Microsoft Azure](https://blogs.msdn.microsoft.com/azurelinux/2016/07/22/deploying-a-nixos-vm-on-microsoft-azure/)
- [Building mobile apps with Nix](http://www.slideshare.net/sandervanderburg/building-mobile-apps-with-the-nix-package-manager)
- [Nix support in Travis](https://docs.travis-ci.com/user/languages/nix)
- [Too many issues open](https://github.com/NixOS/nixpkgs/issues/17407)
- IFD [nix#954](https://github.com/NixOS/nix/issues/954)


# This month in Nix - News from the front 2/2

- Nix C++ migration is progressing [nix#341](https://github.com/NixOS/nix/issues/341)
- Nix and [IPFS](https://ipfs.io/) [nix#859](https://github.com/NixOS/nix/issues/859)
- [Nix Docker image updated](https://hub.docker.com/r/nixos/nix/)
- [VulNix 1.0 released!](https://blog.flyingcircus.io/2016/07/27/vulnix-v1-0-release/)
- [Purely Functional Linux with NixOS](https://begriffs.com/posts/2016-08-08-intro-to-nixos.html)
- [Nix on Vultr](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/vultr)


# Hydra


# Hydraとは 1/3

- Nixプロジェクトの[一部](http://nixos.org/hydra/)
- NixOSとnixpkgsの継続インテグレーション兼ビルドファーム


# Hydraとは 2/3

- Nixベースの汎用的な
    - 継続インテグレーションシステム
    - ビルドファーム
- NixOSでバイナリパッケージを利用できるのはHydraのおかげ


# Hydraとは 3/3

- Nixの自動化システム
- `nix-build` on steroids


# 注意

- 正式リリースされていない
- ドキュメンテーションはほぼ存在しない
- 設定はnix expressionで書く必要がある
- 現時点で使うには努力がいる


# 特徴

- 汎用性: いろいろな言語や技術対応
    - [RPM、DEBパッケージ生成](https://github.com/NixOS/nix/blob/master/release.nix)
- 変動性: 複数バージョン、環境サポート
- マルチプラットフォーム
    - クロスコンパイル
    - [機能別でマシン選択](http://nixos.org/nix/manual/#chap-distributed-builds)
- 冗長性: クラスター、分散ビルド対応
- 拡張性、カスタマイズ性
    - [android用のapkファイル生成](http://sandervanderburg.blogspot.jp/2013/04/setting-up-hydra-build-cluster-for.html)


# Hydraの仕組み

- `.nix`で定義されたパッケージセット(jobset)を評価します
- jobsetはセット、バリューはnix expression
- jobsetのすべてのnix expressionを評価


# 継続インテグレーション

- 自動的にソースを取得とビルド
- 前評価と比較
- log保存
- 失敗の場合にメンテナへメール送信


# ビルドファーム

- ビルドされたパッケージとクロージャー（パッケージと依存）をダウンロード可
- 自動的にチャンネル生成
- 任意チャンネル生成
- リリース


# Jobset

- セット(関数で生成可能)
- 例、Hydra用の
    - [nixpkgs jobset](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release.nix)と[その結果](http://hydra.nixos.org/jobset/nixpkgs/trunk)
    - [nixops jobset](https://github.com/NixOS/nixpkgs/blob/master/nixos/release-combined.nix)と[その結果](http://hydra.nixos.org/jobset/nixos/trunk-combined)
- nixpkgsの[`pkgs.releaseTools`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/release/default.nix)にヘルパー関数
    - `aggregate`: 複数のジョブを一つにまとめます


# Hydraのコンポネント

- サーバ: ビルド結果と情報を確認できるWebアプリケーション
- `queue-runner`: インプットの変更をチェック、ビルドを管理する
- `evaluator`: ジョブを評価する
- Nix Daemon: パッケージと依存関係をビルド(Nix)


# Hydraで生成できる物

- Nixパッケージで生成できるすべての物
    - ソースパッケージ
    - バイナリパッケージ
    - マニュアル
    - ドキュメンテーション
    - ユニットテスト
    - ...


# インストール

- Nixが必要、NixOSがおすすめ
    - NixOSコンテナー内ではHydraを利用できません
- NixOSの`nixos-unstable`であれば、[モジュール](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/continuous-integration/hydra/default.nix)があります
    - NixOS 16.09に正式入る予定です
- 基本設定(`configuration.nix`):

    ```nix
    services.hydra = {
      enable = true;
      hydraURL = "hydra.example.org";
      notificationSender = "admin@hydra.example.org";
    };
    ```


# NixOpsでインストール例

- `examples/single`
- `examples/cluster`


# Webインターフェイス

- Perlで書かれています
- [Elmでテンプレートを書き直し中](https://github.com/NixOS/hydra/issues/314)
- Projects - Jobsets
- ProjectはJobsetの箱です


# Webインターフェイス - Project

- `enabled`: プロジェクトを有効にする
- `identifier`: 識別子
- `display name`: Webインターフェイスに利用されるプロジェクト名
- `description`: プロジェクト概要
- `homepage`: プロジェクトのホームページ
- `owner`: プロジェクトの所有者


# Webインターフェイス - Jobset

- state: Jobsetのステート
- inputs: Jobsetの変数
    - 一つは評価するNix expressionのソース
    - 残りはNix expressionの引数
- Nix expression: ビルドするNix expression (jobsetファイル)
    - `FILE.nix` in `INPUT`
- shares: 利用できるCPUパワーの割合
- [宣言的jobset](https://github.com/NixOS/hydra/pull/316)も利用できます


# Jobsetソース: 三つのアプローチ

- カスタムnixpkgsベース
- 単独ソフトウェア
- カスタムパッケージセット


# nixpkgsベース

- 変更したnixpkgsに独自`release.nix`を作成
- Hydraでビルド


# 単独ソフトウェア

- nixで管理するように
    - `shell.nix`: 開発環境用のnixファイル
    - `build.nix`: プロジェクトをビルドできるnixファイル
    - `release.nix`: Hydraのjobsetファイル
- サンプル: [binserver](https://github.com/ericsagnes/binserver)


# カスタムパッケージセット

- `nixpkgs`の構造を真似て作る
    - パッケージセットを定義し、外部ソースを取得
- サンプル
    - [hydra-pg](https://github.com/ericsagnes/hydra-pg)
    - [vuizvui](https://github.com/openlab-aux/vuizvui)


# リンク集

- 2016年
    - [Hydra: Setting up your own build farm](https://github.com/peti/hydra-tutorial) [video](https://www.youtube.com/watch?v=RXV0Y5Bn-QQ)

- 2014年
    - [Hydra: Continuous Integration and Testing for Demanding People: The Details](http://www.slideshare.net/sandervanderburg/doc-43292714)

- 2013年
    - [NixOS + Hydra + Nginx](http://blog.matejc.com/blogs/myblog/nixos-hydra-nginx/)
    - [Setting up a Hydra build cluster 1](http://sandervanderburg.blogspot.jp/2013/04/setting-up-hydra-build-cluster-for.html)
    - [Setting up a Hydra build cluster 2](http://sandervanderburg.blogspot.jp/2013/04/setting-up-hydra-build-cluster-for_10.html)
    - [Setting up a Hydra build cluster 3](http://sandervanderburg.blogspot.jp/2013/06/securing-hydra-with-reverse-proxy.html)

- 2008年
    - [The Nix Build Farm: A Declarative Approach to Continuous Integration](https://nixos.org/~eelco/pubs/buildfarm-wasdett2008-final.pdf)

- 2007年
    - [Automated Software Testing and Release with Nix Build Farms](https://pure.tue.nl/ws/files/2239914/628612.pdf)

# Questions - Free talk
