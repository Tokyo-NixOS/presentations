% Nixエコシステム ― Full Stack Deployment ―
% サニエ エリック
% 2017年9月9日 - オープンソースカンファレンス <br/><br/>[https://github.com/Tokyo-NixOS/presentations](https://github.com/Tokyo-NixOS/presentations) <br/><br/>検索エンジン: NixOS プレゼンテーション

# 自己紹介

- サニエ エリック
- [東京NixOSミートアップ](http://www.meetup.com/Tokyo-NixOS-Meetup/)オーガナイザー
- [NixOS](http://nixos.org/)コントリビューター
- [Styx静的サイトジェネレーター](https://styx-static.github.io/styx-site/)作成者


# アジェンダ

- Full Stackについて
- Nixエコシステムの紹介


# Full Stackの定義

- 全開発スタック(層)
- 使い方は主にFull Stack developer
    - 「何でもできる技術者(自称)」


# Full Stack Developer

- 幅広いスキル
- 幅広いツールセット
- フロントエンド色が強い?


# DevOpsと比較してみる

- Full Stack
    - 個人中心
    - [縦式](http://www.mangeshdekate.com/explore/wp-content/uploads/2016/09/stackCover.jpg)
- DevOps
    - 組織、プロセス中心
    - [∞式](https://cdn.edureka.co/blog/wp-content/uploads/2016/10/Devops-Cycle-01-1.png)


# DevOps / Full Stackの課題

- 多くの技術とツール
- よく変わる技術
- スタック選択
- スタックの相性・管理やすさ


# 運用管理の問題

- 統一性の無さ（フランケンシュタインシステム） 
- 設定方法(UX)
    - シリアライズ言語なのにロジック!? (Yaml+α、JSON+α、その他の化物)


# 例

- kubernetes: [helm charts](https://docs.helm.sh/chart_template_guide/#flow-control)
- Terraform: [interpolation](https://www.terraform.io/docs/configuration/interpolation.html)
- Ansible: [conditionals](http://docs.ansible.com/ansible/latest/playbooks_conditionals.html)
- Packer: [conditionals](https://www.packer.io/docs/templates/user-variables.html)
- Docker: [like a boss](https://blog.dockbit.com/templating-your-dockerfile-like-a-boss-2a84a67d28e9)


# ジレンマ

- シリアライズ言語は技術者の共通点
    - 使いやすい、わかりやすい
- だが複雑設定には力不足
    - -> 無理やりに独自ロジックシステムを埋め込んで
    - 使いにくい、わかりにくい、限界あり


# 結論

- シリアライズ言語は運用管理設定に力不足
- 設定言語はシステムのカスタマイズ性ボトルネックになりやすい


# 本題（やっと！）

- Nixエコシステム
    - 複数コンポネント
- メインプロジェクト: [NixOS](http://nixos.org/)
    - Linux Distribution


# Nixエコシステム - メインコンポネント

- [Nix](http://nixos.org/nix): ビルドシステム・パッケージマネジャー
- [NixOS](http://nixos.org/): Linux distribution
- [Hydra](http://nixos.org/hydra): 継続インテグレーション
- [NixOps](http://nixos.org/nixops): デプロイメントツール
- [DisNix](http://nixos.org/disnix): マイクロサービスデプロイメントツール
- **Nix言語**: DSL言語


# Nix言語

- 一言で: ラムダ計算 + セット
- ≒ JSON + 関数 + テンプレート
- 少ないデフォルトファンクションとキーワード
    - でも拡張しやすい
    - シンプル、わかりやすい
- REPLもあります: `nix-repl`


# Nix言語

- データシリアライズ

    ```nix
    {
      name = "John Doe";
      age = 21;
      hobbies = [ "sports" "computer" ];
    }
    ```


- データ + ロジック: 

    ```nix
    {
      a = [1] ++ [2 3 4];
      b = if (1+1) == 2 then "現実" else "夢";
    }

    -> {
         a = [ 1 2 3 4 ];
         b = "現実";
       }
    ```

- 関数

    ```nix
    let
      f = x: x + 1;
    in map f [1 2 3]

    -> [2 3 4]
    ```

- currying

    ```nix
    let
      add   = a: b: a + b;
      plus2 = add 2;
    in plus2 10

    -> 12
    ```


# Nix言語

- Nix: [ビルドレシピ](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix)
- NixOS: 設定、[モジュールシステム](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/wicd.nix)
- Hydra: ジョブ定義、[テスト](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/i3wm.nix)
- NixOps: デプロイメント定義
- DisNix: デプロイメント定義


# NixOS

- Linux Distribution
- サーバ、デスクトップ両方向け
- [GitHub](https://github.com/NixOS/nixpkgs/)で管理されている
    - [コントリビューションレートはGitHubのTop 10以内](http://krihelinator.xyz/)
    - [レビューアー数はGitHubの6位](https://octoverse.github.com/)
- **宣言型設定**
- パッケージマネジャー (Nix)
    - 複数バージョンの同時インストール可
    - ルート権限不要
    - ユーザレベルでパッケージ管理
- [ロールバック機能](https://nixos.org/nixos/screenshots/nixos-grub.png)


# NixOS:宣言型設定

- 一つの設定ファイルでOSを完全設定
- 宣言型: 何でなく、どう
- モジュールベース -> 拡張性


# NixOS設定

- X Server設定

    ```nix
    services = {
      xserver = {
        enable = true;
        layout = "jp";
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;
      };
    };
    ```

- ソフトウェアのインストール (プロビジョニング)

    ```nix
    environment.systemPackages = [
      pkgs.firefox
      pkgs.git
      (import ./my-pkg)
    ];
    ```

- Webサーバ

    ```nix
    services.nginx = {
      enable = true;
      virtualHosts."www.me.com" = {
        enableACME = true;
        locations."/" = {
          root = "/var/www/www.me.com";
        };
      };
    };
    ```

- データベース

    ```nix
    services.postgresql.enable = true;
    ```

- ファイヤーウォール設定

    ```nix
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    ```

# NixOps

- NixOS設定のデプロイメントツール
- 複数バックエンド対応 (AWS、GCP、Azure、オンプレ、...)
- 複数マシン（ネットワーク）のデプロイ


# エコシステムの利点

- 技術の統一性、例:
    - Nixで定義したパッケージを
    - NixOSの設定にインポート
    - NixOpsでデプロイ
- オンプレスタック
- カスタマイズ性・柔軟性
    - [Ethereum Marketplace](http://fractalide.com/)
    - [機械学習パイプライン](https://github.com/Tokyo-NixOS/presentations/blob/master/2017/06/machine-learning/readme.jp.md)
    - [静的サイトジェネレーター](https://styx-static.github.io/styx-site/)


# 以外と使われている

- [Human Brain Project](https://www.humanbrainproject.eu/en/)
- [Blue Brain Project](http://bluebrain.epfl.ch/)
- Mozilla: [release management](https://github.com/mozilla-releng/services)
- [Lumiguide](https://lumiguide.nl/): [Talk](https://www.youtube.com/watch?v=IKznN_TYjZk) - Nix, LumiOS (Custom NixOS), NixOps
- [RhodeCode](https://rhodecode.com/): SCM - use nix in CLI tool, CI - [Article](https://rhodecode.com/blog/61/rhodecode-and-nix-package-manager)
- [Evidentiae Technologies](http://www.evidentiaetechnologies.com/): Medical - NixOS
- [Best Mile](https://bestmile.com/): Autonomous vehicles cloud platform - NixOS, NixOps
- ...

# ありがとうございます!
