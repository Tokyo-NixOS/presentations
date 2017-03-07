% Nix Expression Language
% サニエ エリック
% 2016年4月14日 - Tokyo NixOS Meetup

# アジェンダ

- ニュース
- Nix言語一通り紹介
- ビルトイン紹介（一部）
- モジュールシステム紹介
- Nix Expression例
- Nix言語チュートリアル


# This month in Nix - [News from the front](https://github.com/NixOS/nixpkgs)

- [NixOS 16.03 released!](http://nixos.org/nixos/manual/release-notes.html#sec-release-16.03)
- [multiple outputs / closure size PR merged!](https://github.com/NixOS/nixpkgs/pull/7701) 
- [RFC: remove node packages](https://github.com/NixOS/nixpkgs/issues/14532)
- [service hardening](https://github.com/NixOS/nixpkgs/issues/14645)
- ~~[Unstable channel hasn't updated for 2+ weeks](https://github.com/NixOS/nixpkgs/issues/14595)~~


# This month in Nix - [Reddit topics](https://www.reddit.com/r/NixOS/)

- [NeoVIM configuration example](https://github.com/seagreen/vivaine/blob/master/extended-config/vim/c.nix)
- [odroid xu4 with nixos](https://lastlog.de/blog/posts/odroid_xu4_with_nixos.html)
- [NixOS on a MacBook Pro](https://www.reddit.com/r/NixOS/comments/4d2dhq/nixos_on_a_macbook_pro/)
- [From Zero to Application Delivery with NixOS](http://www.slideshare.net/mbbx6spp/from-zero-to-application-delivery-with-nixos)


# This month in Nix - [ML topics](http://news.gmane.org/gmane.linux.distributions.nixos)

- [staging merged](http://article.gmane.org/gmane.linux.distributions.nixos/19964)
- [Status: Transparent Security Updates](http://article.gmane.org/gmane.linux.distributions.nixos/19965)
- [GNU Guix & GuixSD 0.10.0 released](https://www.gnu.org/software/guix/)
- [nix-1.11.2 on dockerTools.buildImage](https://gist.github.com/aespinosa/6c979bebfda9d78b181a95e08524ef72)
- [ Trying to implement quicksort in nix...](http://news.gmane.org/find-root.php?message_id=20160413123922.GH3592%40yuu)


# This month in Nix - [Tokyo NixOS](https://github.com/Tokyo-NixOS/)

- 4月22日に[Wakame User Group](http://axsh.jp/community/wakame-users-group.html)にNixを紹介します
- [fcitx input method do not work on unstable and 16.03](https://github.com/NixOS/nixpkgs/issues/14019)
    - ~~[PR1](https://github.com/NixOS/nixpkgs/pull/14417)~~ [PR2](https://github.com/NixOS/nixpkgs/pull/14568)
- [インプットメソッドドキュメンテーション](https://github.com/NixOS/nixpkgs/pull/14602)


# Nix Expression Language

- Nix Expression language != Nix
    - NixはNix言語のコンパイラー
- パッケージ用のドメイン固有言語
- 純粋（pure）
    - 副作用はない
- 延長評価（lazy）
    - 必要な値のみを評価します
- 関数型（functional）
    - 関数を値の様に操作できる
- 動的型付け
- [公式ドキュメンテーション](http://nixos.org/nix/manual/#ch-expression-language)


# Nix Expression Language: ユーズケース

- パッケージ
- モジュール
- 開発環境シェル
- 設定・プロビジョニング
- コンテナー
- デプロイメント（NixOps経由）
- 継続インテグレーションジョブ（Hydra経由）
- テスト
- dockerイメージ
- `make`の代わり


# Nix Expression language: 評価

- `nix-intantiate` コマンド
    - 使い方

        ```sh
        nix-instantiate  --eval -E '1 + 3'
        ```

    - デフォルトは延長評価

        ```sh
        nix-instantiate --eval -E 'rec { x = "foo"; y = x; }'
        ```

    - `--strict`で先行評価

        ```sh
        nix-instantiate --eval -E --strict 'rec { x = "foo"; y = x; }'
        ```

- `nix-repl` コマンド


# 型: 文字列

- 書き方

    ```nix
    "foo bar"
    ```

    ```nix
    "
    foo
    bar
    "
    ```

- インデントを含む数行の文字列も書けます

    ```nix
    ''
      foo
      bar
    ''
    ```

- `${}`で文字列に評価できるNix expressionの結果を文字列に入れる事はできます

    ```nix
    "--with-freetype2-library=${freetype}/lib"
    ```

- [RFC2396](http://www.ietf.org/rfc/rfc2396.txt)に準拠したURIを`""`に囲まず書く事ができます ([関連討論](https://github.com/NixOS/nix/issues/836))

    ```nix
    http://example.org/foo.tar.bz2
    ```


# 型: その他

- 整数
    - `123`
- パス 
    - `./builder.sh`
    - `../../foo.nix`
    - パスは記載されたファイルから相対的に評価されます
- ブーリアン
    - `true` | `false`
- null
    - `null`
- 小数点([master](https://github.com/NixOS/nix/pull/762))


# 型: リスト

- リストは`[]`で囲む
- セパレーターは空白
- 異なった型を含む事ができます
- 例

    ```nix
    [ 123 ./foo.nix "abc" (f { x = y; }) ]
    ```

- リストと延長評価
    - 値は延長評価
    - リストはサイズは先行評価（無限リスト不可）


# 型: セット

- セットはNix言語の中心型となります
- 一般なキーバリュー型
- 例

    ```nix
    { 
      x = 123;
      text = "Hello";
      y = f { bla = 456; };
    }
    ```

- `.`でキーの値をアクセスできます

    ```nix
    { a = "Foo"; b = "Bar"; }.a

    # => "Foo"
    ```

# 言語構造: `rec`

- `rec`キーワードで再帰セット宣言

    ```nix
    rec {
      x = y;
      y = 123;
    }.x

    # => 123
    ```

- 無限再帰の危険はあります

    ```nix
    rec {
      x = y;
      y = x;
    }.x

    # 無限再帰
    ```

- 利用例: パッケージの`name`と`version`

    ```nix
    rec {
      name = "foo-${version}";
      version = "1.0.0";
    }
    ```

# 言語構造: `let`

- `let`でローカル変数を定義できます

    ```nix
    let
      x = "foo";
      y = "bar";
    in x + y

    # => "foobar"
    ```


# 言語構造: `inherit`

- `inherit`で外部スコープの変数を利用する

    ```nix
    let x = 123; in
    { 
      inherit x;
      y = 456;
    }
    
    # => { x = 123; y = 456; }
    ```

- `inherit a b`外部スコープ`a`セットの`b`属性を利用する

    ```nix
    graphviz = (import ../tools/graphics/graphviz) {
      inherit fetchurl stdenv libpng libjpeg expat x11 yacc;
      inherit (xlibs) libXaw;
    };
    
    xlibs = {
      libX11 = ...;
      libXaw = ...;
      ...
    }
    
    libpng = ...;
    libjpg = ...;
    ...
    ```

# 関数

- 書き方

    ```nix
    pattern: body
    ```

    ※ `:`の後の空白は必須です

- 例:

    ```nix
    x: x
    ```

    ```nix
    x: y: x + y
    ```

- カリー化:

    ```nix
    let add = (x: y: x + y); in add 3 4

    # => 7
    ```

    ```nix
    let add1 = (x: y: x + y) 1; in add1 2

    # => 3
    ```


# 関数: セット

- 引数でセットを利用できます

    ```nix
    let add = { x, y }: x + y; in add { x = 2; y = 2; }

    # => 4
    ```

- `?`で引数セットのデフォルト値を設定

    ```nix
    let add = { x ? 1, y }: x + y; in add { y = 2; }

    # => 3
    ```

- `@`パターンでセット全体をマッチ


    ```nix
    let foo = args@{ x, ... }: args.a; in add { x = 2; y = 2; a = 42; }

    # => 42
    ```

- functor (Haskellとは別物)

    ```nix
    let add = { __functor = self: x: x + self.x; };
    inc = add // { x = 1; };
    in inc 1

    # => 2
    ```


# その他の構造

- `if e1 then e2 else e3`: 分岐

- `assert e1; e2`: アサーション

    - `e1`が`true`に評価される場合は`e2`は返されます
    - `e1`が`false`に評価される場合は評価が中止され、メッセージが表示されます


- `with e1; e2`: `e1`セットのキーをを`e2`のスコープに入れます

    ```nix
    let as = { x = "foo"; y = "bar"; };
    in with as; x + y
    ```

- コメント

    ```nix
    # シングルラインコメント

    /*
     マルチライン
     コメント
    */
    ```


# オペレーター

- `s.a`: セット`s`から`a`属性をを呼び出す
- `e1 e2`: 関数呼び出し,`e1`関数を`e2`引数で呼ぶ
- `s ? a`:セット`s`の`a`属性存在確認、`true` | `false`を返します
    - 関数のセット引数の`?`とは異なります
- `e1 ++ e2`: リスト合体
- `e1 + e2`: 文字列とパスの合体、整数の足し算
    - 文字列はリストではありません
- `! e1`: ブーリアンノット
- `s1 // s2`: `s1`と`s2`の属性を含んだセットを返す
    - 同じキーが両セットに損祭する場合は`//`の右のセットが優先されます（`s2`）
- `e1 == e2`: `e1`は`e2`と等しい
- `e1 != e2`: `e1`は`e2`と異なる
- `e1 && e2`: 論理積
- `e1 || e2`: 論理和
- `e1 -> e2`: = `!e1 || e2`


# ビルトイン関数（一部）

- `abort s`: 評価を中止して、`s`エラーメッセージを表示
- `builtins.all pred list`

    ```nix
    let even = (x: (x - 2 * (x / 2)) == 0); in builtins.all even [ 2 4 6 ]

    # => true
    ```

- `builtins.filter pred list`


    ```nix
    let even = (x: (x - 2 * (x / 2)) == 0); in builtins.filter even [ 1 2 3 4 5 6 ]

    # => [ 2 4 6 ]
    ```

- `import`: Nixファイルをインポートする

    ```nix
    import ./foo.nix
    ```

- `map f list`:

    ```nix
    let square = x: x*x; in map square [1 2 3 4]

    # => [ 1 4 9 16 ]
    ```

- `builtins.toFile name s`: Nixストアにファイルを生成します
    
    ```nix
    builtins.toFile "hello.txt" "hello"

    # => /nix/store/q790zdjk75hm2cn42nh77pqw4gbv1b88-hello.txt
    ```


# モジュールシステム

- Nix言語 + 型
- `mkOption`関数でオプションを作成
- `interface`(`options`)と`implementation`(`config`)でわかれています
- 例
    - [tmux](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/tmux.nix)
    - [neo4j](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/databases/neo4j.nix)


# Nix Expressionの例

- [パッケージ](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix)
- [単独パッケージ](https://github.com/ericsagnes/binry/blob/master/release.nix)
- [単独モジュール](https://github.com/ericsagnes/binserver/blob/master/module.nix)
- [Nix shell](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/tree/master/nix-shells)
- 環境設定・プロビジョニング
- [型定義](https://github.com/NixOS/nixpkgs/blob/master/lib/types.nix)
- [リスト関数](https://github.com/NixOS/nixpkgs/blob/master/lib/lists.nix)
- [nixpkgs Hydraジョブ](https://github.com/NixOS/nixpkgs/blob/master/nixos/release-combined.nix)
- [デプロイメント](https://github.com/NixOS/nixops/tree/master/examples)
- [テスト](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/containers.nix)
- [マニュアル生成](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/default.nix)
- [資料作成](https://github.com/Tokyo-NixOS/presentations/blob/master/mkPresentation.nix)


# チュートリアル

- [Tour of Nix](https://nixcloud.io/tour/)


# ありがとうございます！

- 質問タイム
- 次の課題アイデア募集


# リンク

* [Nixマニュアル](https://nixos.org/nix/manual/) (英語)
* [日本語Wiki](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki)
* [過去のミートアップ資料](https://github.com/Tokyo-NixOS/presentations)
* [NixOSマニュアル](http://nixos.org/nixos/manual/) (英語)
* [パッケージ検索](http://nixos.org/nixos/packages.html) (英語)
* [モジュールオプション検索](http://nixos.org/nixos/packages.html) (英語)
* [Contributor Guide](http://nixos.org/nixpkgs/manual/) (英語)
