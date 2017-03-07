% nixpkgs
% サニエ エリック
% 2016年6月24日 - Tokyo NixOS Meetup

# アジェンダ

- ニュース
- nixpkgsとは
    - 構造
    - ライブラリ
    - プログラミング言語サポート
    - NixOS
- Free talk


# This month in Nix 

- [Rework goPackages](https://github.com/NixOS/nixpkgs/pull/16017)
- [Python: buildPyPIPackage and generated data](https://github.com/NixOS/nixpkgs/pull/16005)
- [DisNix 0.6](https://nixos.org/disnix/)
- [Nix: Get rid of the Perl dependency (rewrite in C++, too bad not in Haskell!)](https://www.reddit.com/r/haskell/comments/4mda0e/nix_get_rid_of_the_perl_dependency_rewrite_in_c/)
- [Haskell LTS support change](http://thread.gmane.org/gmane.linux.distributions.nixos/20505)

# This month in Nix 

- [Hydra and Hydra service in nixpkgs](https://github.com/NixOS/nixpkgs/commit/3e631800d1ddc93523be4a3a6880a33dc80efb2e#diff-0cdf8d0fe885d9051bf6463bd4e653db)
- [Malicious installation methods](http://thread.gmane.org/gmane.linux.distributions.nixos/20662)
- [Nix on Jolla](http://thread.gmane.org/gmane.linux.distributions.nixos/20711)
- [Using string as path to eg. builtins.readFile](http://thread.gmane.org/gmane.linux.distributions.nixos/20729)

    ```nix
    nix-repl> ./ + "/foo"
    error: syntax error, unexpected '.', at (string):1:1

    nix-repl> ./. + "/foo"
    /home/eric/Projects/nixos/nixpkgs/foo
    ```
- [Nixパッケージ作成](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/packaging)

# Nix Trick

- Hydraでのパッケージ評価を確認

    ```nix
    nix-repl> :l ./nixos/release-combined.nix
    Added 3 variables.

    nix-repl> nixpkgs.php
    { i686-linux = «derivation /nix/store/jnh3rdr9bxp0yi1kcsi9pcd2cga43njb-php-5.6.22.drv»; x86_64-linux = «derivation /nix/store/11bxnw1bkfmzjwrjhccr2g39bdy8xjaq-php-5.6.22.drv»; }
    ```


# nixpkgs

- [gitレポジトリ](https://github.com/NixOS/nixpkgs)
- Nix(パッケージマネージャー)のパッケージ(レシピ)セット
- それ以外
    - NixOSのコード・モジュール・テスト
    - nixpkgsとNixOSのドキュメンテーション
- [マニュアル](https://nixos.org/nixpkgs/manual/)


# ローカルnixpkgsの利点

- カスタムなパッケージセット、モジュールを利用できます
- 自サーバHydraと組める


# nixpkgsをゲット

- `git`でクローンできます

    ```sh
    $ git clone https://github.com/NixOS/nixpkgs.git
    ```

- チャンネルのリモートを追加するとテストの際にバイナリパッケージを利用できます

    ```sh
    $ cd nixpkgs
    $ git remote add channels https://github.com/NixOS/nixpkgs-channels.git
    $ git fetch channels
    ```


# nixpkgsの使い方

- ローカルnixpkgsからパッケージを検索する

    ```sh
    $ nix-env -qaf ./ firefox
    ```

- ロカールnixpkgsからシェルを起動する

    ```sh
    $ nix-shell -p htop -I nixpkgs=./
    ```

- ローカルnixpkgsからパッケージをビルド

    ```sh
    $ nix-build -A htop
    ```


# nixpkgsのフォルダー構造

- `doc`: nixpkgsのドキュメンテーション
- `lib`: Nix言語のライブラリ関数
- `maintainers`: メンテナ用のスクリプト等
- `nixos`: NixOS関連コード
- `pkgs`: メインフォルダー、パッケージセット


# doc

- xml形式のnixpkgsドキュメンテーション
- `language-frameworks`にプログラミング言語のドキュメンテーション
- `default.nix`でマニュアルビルドエクスプレッション
- ビルドできます

    ```sh
    $ nix-build doc/default.nix
    ```


# lib

- Nix言語のライブラリ
    - セット、リスト、文字列等の関連関数
- NixOSモジュールシステムライブラリ
- メンテナ、対応システム、ライセンス一覧


# pkgs

- すべてのパッケージ定義
    - `pkgs/top-level/all-packages.nix`
- フォルダーでパッケージの種類が別れています
    - 多少不規則
    - 似たパッケージがあれば(`grep`で検索)同様な構造にするが無難


# `all-packages.nix`まで

- `default.nix`: Nixのバージョンチェック
- `pkgs/top-level/default.nix`
    - システムチェック
    - ライブラリのインポート
    - 設定ファイルの読み込み(`~/.nixpkgs/config.nix`)
    - オーバーライドを適応
- `pkgs/top-level/all-packages.nix`: すべてのパッケージセット
- ノート: `all-packages.nix`までの流れを改善する[PR](https://github.com/NixOS/nixpkgs/pull/15043)があります


# `all-packages.nix`

- すべてのパッケージをまとめるファイル
- 17000行、多少カオス
- パッケージ追加に必ず変更する


# パッケージの追加

- 流れ
    - パッケージファイルを作る
    - `all-packages.nix`にパッケージ呼び出しを追加
- 参考書
    - [マニュアル](https://nixos.org/nixpkgs/manual/)
    - [日本語wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/packaging)


# プログラミング言語対応

- `pkgs/development/`以下に入っています
- 言語によってサポートは不平等
    - Haskellは特によくサポートされています
- 言語毎に統一性は少ない(専用DSLに近い)
    - が最近は改善されています
    - Haskellがベース(`withPackages`など)
- 最近は言語毎の全パッケージで[自動的に全パッケージセットを生成する](https://github.com/NixOS/nixpkgs/issues/15480)
    - [だが難しいようです](https://github.com/NixOS/nixpkgs/issues/15480#issuecomment-227720830)


# Hydraとの連携

- Hydraのジョブはnixpkgsで定義されています
- `pkgs/top-level/release.nix`に宣言
- `x86_64-linux`、`i686-linux`と`x86_64-darwin`対応
    - `pkgs/top-level/release-cross.nix`で他のシステム
- 流れ
    - Hydraはgitレポジトリから定期的に`pkgs/top-level/release.nix`を[チェックアウト](http://hydra.nixos.org/jobset/nixpkgs/trunk#tabs-configuration)
    - [`unstable`](http://hydra.nixos.org/job/nixpkgs/trunk/unstable#tabs-status)ジョブの評価


# nixos

- NixOS関連コード
- `nixos`
    - `doc`: NixOSのドキュメンテーション
    - `lib`: NixOS専用ライブラリ（モジュールシステム、テスト関連）
    - `modules`: 各モジュールの宣言
    - `tests`: リリース用のテスト
    - `release.nix`: NixOS関連のジョブ（マニュアル、バーチャルマシンなど）
    - `release-combined.nix`: NixOSとnixpkgsのHydraのジョブ


# modules

- NixOSのメインコード
- `pkgs`と同様、種類別でフォルダー分けています
- 各モジュールは宣言(`options`)とロジック(`config`)を含む
- モジュールのドキュメンテーションも含まれます


# tests

- 各テスト宣言
- 専用なライブラリ（`nixos/lib/test-driver/Machine.pm`）
- テストはQemuバーチャルマシンで実行されます
- 正常に終わると結果にHTMLレポートができます
- 手動で実行可能

    ```sh
    $ nix-build nixos/release.nix -A tests.i3wm
    ```


# release.nix

- NixOSのHydraジョブ
- マニュアル

    ```sh
    $ nix-build nixos/release.nix -A manual
    ```

    ```sh
    $ nix-build nixos/release.nix -A manualPDF
    ```

- バーチャルマシンイメージ


    ```sh
    $ nix-build nixos/release.nix -A ova
    ```

- NixOSのインストールCDイメージ

    ```sh
    $ nix-build nixos/release.nix -A iso_minimal
    ```

- テスト


    ```sh
    $ nix-build nixos/release.nix -A tests.i3wm
    ```


# Free talk ideas

- Question time
- Nix Expressionの解読
- `stdenv`の仕組み
- `lib`関数チェック

