% Hydra
% サニエ エリック
% 2017年3月24日 - Tokyo NixOS Meetup


# News

- [OSC Spring](https://www.ospn.jp/osc2017-spring/) - [プレゼンテーション](https://github.com/Tokyo-NixOS/presentations)


# 前回の復習

- Nixはパッケージマネジャーを超えて...
- 万能ビルドシステムであります
    - クリーンビルド
    - ビルドの再現性
    - ビルドコンポネントの再利用
- 何でもビルドできます
    - Python, Ruby, NodeJSなどパッケージ
    - [この資料](https://github.com/Tokyo-NixOS/presentations)
    - [静的ウェブサイト](https://github.com/styx-static/styx)
    - [Dockerイメージ](https://nixos.org/nixpkgs/manual/#sec-pkgs-dockerTools)
    - [アンドロイドアプリケーション](http://sandervanderburg.blogspot.jp/2012/11/building-android-applications-with-nix.html)
    - マニュアル・ドキュメンテーション
    - ISOイメージ
    - テスト
    - [メトリックス](http://hydra.nixos.org/job/nixpkgs/trunk/metrics#tabs-charts)


# 前書 - 注意

- Hydraの正式リリースはない
- ドキュメンテーションはほぼ存在しない
- Jobsetはnix言語で書く必要がある
- hydra.nixos.org で利用される前提で開発されています
- 現時点で使うには多少努力がいる


# Hydra

- Nixのメインプロジェクトの[一つ](http://nixos.org/hydra/)
- Nixの自動化ツール+α
- NixOS/nixpkgsの**継続インテグレーション**と**ビルドファーム**
- Nix/NixOSでバイナリパッケージを利用できるのはHydraのおかげ


# Hydra (Nix)

- 環境の管理
- 分散ビルド
- マルチプラットフォーム
- パッケージのバリエーション


# 継続インテグレーション

- 自動的にソースを取得とビルド
- 前評価と違いを比較
- ビルドログ保存
- 失敗の場合にメンテナへメール送信
- カスタムビルドプロダクト


# ビルドファーム

- ビルドされたパッケージとクロージャー（パッケージと依存）をダウンロード可
- カスタムビルドプロダクト
- Nixチャンネル生成


# 特徴

- 汎用性: いろいろな言語や技術対応
    - [RPM、DEBパッケージ生成](https://github.com/NixOS/nix/blob/master/release.nix)
- 変動性: 複数バージョン、環境サポート
- マルチプラットフォーム
    - クロスコンパイル
    - [機能別でビルドマシン選択](http://nixos.org/nix/manual/#chap-distributed-builds)
- 冗長性: クラスター、分散ビルド対応
- 拡張性、カスタマイズ性
    - [android用のapkファイル生成](http://sandervanderburg.blogspot.jp/2013/04/setting-up-hydra-build-cluster-for.html)


# Hydraの構造

- Server: ビルド結果と情報を確認できるWebアプリケーション
- `queue-runner`: インプットの変更をチェック、ビルドを管理する
- `evaluator`: ジョブを評価する
- Nix Daemon: パッケージと依存関係をビルド(Nix)


# Hydraの仕組み

- `.nix`で定義されたJobsetを評価します
- jobsetはアトリビュートセット`{ ... }`でバリューはパッケージ
- すべてのJobsetパッケージをビルド


# Jobset

- セット(動的生成可)
- 例、Hydra用の
    - [nixpkgs jobset](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release.nix)と[Hydra評価](http://hydra.nixos.org/jobset/nixpkgs/trunk)
    - [nixops jobset](https://github.com/NixOS/nixpkgs/blob/master/nixos/release-combined.nix)と[Hydra評価](http://hydra.nixos.org/jobset/nixos/trunk-combined)
- nixpkgsの[`pkgs.releaseTools`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/release/default.nix)にヘルパー関数
    - `aggregate`: 複数のジョブを一つにまとめます


# インストール

- Nixが必要、NixOSで簡単にインストール
    - NixOSコンテナー内ではHydraを利用できません
    - [専用モジュール](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/continuous-integration/hydra/default.nix)
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
- Projects > Jobsets > Evaluations > Jobs


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

