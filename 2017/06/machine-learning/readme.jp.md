# 実験: Nixで機械学習

Nixを使った機械学習を紹介します。
Kerasでmnist数字を使ってConvNetモデルを練習させて。モデルをFlask アプリケーションにデプロイします。


## モデル

モデルはKerasで定義しています。モデルは`model.nix`でビルドできます。

Nixを利用することで:

- 柔軟性: バックエンド、エポックなどをモージュルオプションでカスタマイズできる。
- 決定性: ビルドは再現できます。
- 依存関係: 直接TensorflowやTheanoをインストールする必要なく、すべての依存関係はNixで管理されています。
- 分散ビルド: Nixの分散ビルドを利用して、十分なパワーをもったマシンでモデルをビルドできます。 
- 継続インテグレーション: Hydraを使って、モデルをビルドできます。


### モデルをビルド

デフォルト値、tensorflowバックエンドと10エポック、でモデルをビルドする。

```sh
$ nix-build -A model
```

`default.nix`にはモデルのバリエーションもあります。

`nix-build -E`を使って、パラメータを設定できます。

```sh
$ nix-build -E 'with import ./.; model.override { epochs = 5; }'
```


## フロントエンド

フロントエンドはモデルを利用する簡単なflaskアプリケーション。


## フロントエンド実行

コマンドラインからモデルを実行する:

```sh
$ MODEL=$(nix-build -A model)/model.h5 $(nix-build -A frontend)/bin/cnn-mnist
```


## NixOSモジュール

NixOSはNixを利用したリナックスディストリビューションです。NixOSの宣言型設定で複雑な設定を抽象できます。
とても簡単にカスタムNixOSモジュールを作れます、例えば`module.nix`はフロントエンドアプリケーションのモジュールを定義します:

`module.nix`をNixOSのメイン設定ファイル、`configuration.nix`、にインポートして、利用することができます。
次のコードでモジュールをインポートし、フロントエンドアプリケーションを有効にします。


```nix
  imports = [ /PATH/TO/MODULE/FILE/module.nix ];

  services.cnn-mnist.enable = true;
```

モジュールはアプリケーションをカスタマイズできるオプションを定義します:

- port: アプリケーションのポート
- host: アプリケーションのホスト
- backend: 利用するバックエンド: `theano`か`tensorflow`
- model: 利用するモデル

NixOSモジュールは表現的、次のコードで機械学習アプリケーションをNginxリバースプロクシの後ろで実行できます:

```nix
  services.cnn-mnist = {
    enable  = true;
    port    = 8000;
    backend = "theano";
  };

  # Opening port 80
  networking.firewall.allowedTCPPorts = [ 80 ];
  
  # Nginx frontend 
  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen 80;
        location / {
          proxy_pass          http://127.0.0.1:8000;
          proxy_http_version  1.1;
        }
      }
    '';
  };
```


### デプロイ

NixOps、NixOSコンフィグレーションをデプロイするツール、でリモートサーバにアプリケーションをデプロイできます。

`nixops-deployment.nix`はVirtualBoxデプロイファイルとなります。下記のコマンドでデプロイできます:

```
$ nixops create -d cnn-mnist nixops-deployment.nix
$ nixops deploy -d cnn-mnist
```


# Thanks & Inspiration

- Siraj Raval - [How to Deploy Keras Models to Production](https://www.youtube.com/watch?v=f6Bf3gl4hWY)
- Francois Chollet - [Keras Examples](https://github.com/fchollet/keras/tree/master/examples)
