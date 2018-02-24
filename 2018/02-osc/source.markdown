% Nixパッケージマネジャーの紹介
% サニエ エリック
% 2018年2月24日 - オープンソースカンファレンス <br/><br/> [https://github.com/Tokyo-NixOS/presentations](https://github.com/Tokyo-NixOS/presentations) <br/><br/>Google: NixOS プレゼンテーション

# 自己紹介

- サニエ エリック
- [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)オーガナイザー
- [NixOS](http://nixos.org/)コントリビューター


# パッケージマネジャーとは

- ソフトウェアの
    - インストール
    - アップグレード
    - 削除
- ができるツール


# パッケージマネジャー図

<div style="text-align: center;">
![](assets/osc-normal.png)
</div>


# 有名なパッケージマネジャー

- 一般的
    - `apt` -> ubuntu, debian
    - `yum` -> centos, 
    - `brew` -> MacOS
- 言語
    - `pip` -> Python
    - `composer` -> PHP
    - `gem` -> Ruby


# パッケージマネジャーの大きいな課題

- 依存関係解決
- バージョン管理


# 依存関係地獄

- 依存関係バージョンコンフリクト
- 多くの依存関係
- Circular dependencies (循環依存関係) 


# パッケージとアプリケーション

- パッケージ != アプリケーション
    - 粒度
    - 依存
- アプリケーションの複雑さ ≒ パッケージングの複雑さ


# Post package World

- `curl foo | sh`: [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-convenience-script)
- 実行ファイルのコピー: [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl)
- Dockerイメージでパッケージを提供: [gitlab](https://about.gitlab.com/installation/)


# 対象方法

- Ubuntu snappy, App image, Flatpak
- Nix


# Nix

- ユニバーサルパッケージマネジャー
    - 一般的（OSパッケージ）
    - 言語パッケージ
- Linux、Mac OS、Windowsで利用できる


# Nixの特徴

- 依存関係地獄は**不可能**
- 再現性保証
- 依存関係の完結保証
- (非)権限
- バイナリーインストール・ソースビルド
- 開発者向け


# Nixの秘密

- **環境**と**ファイルシステム**を区別する
- パッケージを関数と考える


# 環境とファイルシステム

<div style="text-align: center;">
![](assets/osc-nix.png)
</div>


# パッケージマネジャー図

<div style="text-align: center;">
![](assets/osc-normal.png)
</div>


# マルチレポジトリ

<div style="text-align: center;">
![](assets/osc-nix-multi.png)
</div>


# Nix: ビルドシステム

- ビルドシステムでもあります
    - パッケージのレシピを書いて
    - `nix-build`でビルド


# Nixレシピ

- パッケージ = 関数
- 依存関係は引数


# なんでもビルドできます

- パッケージ
- ライブラリ
- 独自アプリケーション
- 機械学習モデル
- ウエブサイト・ウェブアプリケーション
- プレゼンテーション


# ビルドも

<div style="text-align: center;">
![](assets/osc-nix-build.png)
</div>


# Nix Tricks

- `nix-shell`
    - `nix-shell -p atom`
- `pkg.override`
    - `pkgs.nginx`
    - `pkgs.nginx.override{ openssl = pkgs.libressl; }`


# Nixエコシステム

- ディストリビューション: [NixOS](https://nixos.org/)
- 継続インテグレーション・ビルドファーム: [Hydra](https://nixos.org/hydra/)
- 運用管理システム: [NixOps](https://nixos.org/nixops/)
- パッケージコレクション: [nixpkgs](https://github.com/NixOS/nixpkgs)


# まとめ

- 依存関係地獄は不可能
- 再現性保証
- 使いやすい
- ユニバーサルビルドシステム
- 環境管理システム
- 豊富なエコシステム


# 最後に

- Nix 2.0は[リリース](https://nixos.org/nix/manual/#ssec-relnotes-2.0)されました!


