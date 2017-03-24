# Hydraのクラスター 例

## ファイル一覧

- `cluster.logical.nix`: NixOpsの論理的ネットワークファイル
- `cluster.physical-vbox.nix`:  NixOpsの物理的ネットワークファイル
- `machine.master.nix`: Hydraサーバの設定
- `machine.slave.nix`: Hydra Slaveの設定


## 手順

クラスター用のキーSSHを生成:

```
$ ssh-keygen -C "hydra@hydra.example.org" -N "" -f id_buildfarm
```

NixOpsでデプロイメントを作成:

```
$ nix-shell -p $(nix-build -A nixops https://github.com/nixos/nixpkgs-channels/archive/nixos-16.09.tar.gz)
$ nixops create -d hydra-cluster cluster.logical.nix cluster.physical.nix
$ nixops deploy -d hydra-cluster -I nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-16.09.tar.gz
```

デプロイメント情報の確認:

```
$ nixops info -d hydra-cluster
```

バイナリパッケージを利用できるようにチャンネルを追加と更新します。

```
$ nixops ssh -d hydra-cluster master -- nix-channel --add https://nixos.org/channels/nixos-16.09 nixos
$ nixops ssh -d hydra-cluster master -- nix-channel --update
```


Webインターフェイスユーザを作成

```
$ nixops ssh -d hydra-cluster master -- hydra-create-user alice --password foobar --role admin
```

Hydraのログを確認:

```
$ nixops ssh -d hydra-cluster master -- journalctl -f -u hydra-queue-runner -u hydra-evaluator
```
