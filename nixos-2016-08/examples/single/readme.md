# Hydraのクラスター 例

## ファイル一覧

- `single.logical.nix`: NixOpsの論理的ネットワークファイル
- `single.physical-vbox.nix`:  NixOpsの物理的ネットワークファイル
- `machine.master.nix`: Hydraサーバの設定


## 手順

NixOpsでデプロイメントを作成:

```
$ nixops create -d hydra single.logical.nix single.physical.nix
$ nixops deploy -d hydra
```

デプロイメントがうまく行かない場合は再度`nixops deploy -d hydra`を実行すれば解決できます。（[バグ](https://github.com/NixOS/nixops/issues/473)）

```
$ nixops deploy -d hydra
```

デプロイメント情報を確認:

```
$ nixops info -d hydra
```

バイナリパッケージを利用できるようにチャンネルを追加と更新します。

```
$ nixops ssh -d hydra hydra -- nix-channel --add https://nixos.org/channels/nixos-unstable nixos
$ nixops ssh -d hydra hydra -- nix-channel --update
```

Webインターフェイス用ユーザを作成:

```
$ nixops ssh -d hydra hydra -- hydra-create-user alice --password foobar --role admin
```

Hydraのログを確認:

```
$ nixops ssh -d hydra hydra -- journalctl -f -u hydra-queue-runner -u hydra-evaluator
```
