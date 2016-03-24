# Tokyo Nixos Meetup Presentation Slides

[Tokyo Nixos Meetup](http://www.meetup.com/ja-JP/Tokyo-NixOS-Meetup/)に紹介された資料を集めるレポジトリです。

2015年:

- 9月: [NixOS Basics](nixos-2015-09/source.markdown) (英語)

2016年:

- 2月: [Packaging 101](nixos-2016-02/source.markdown) (英語)
- 2月OSC: [関数型Linux: NixOSの仕組みと特徴の紹介](nixos-2016-02-osc/source.markdown)
- 3月: [NixOps & Nix DevOps](nixos-2016-03/source.markdown)

Nixで各資料をビルドできます、例:

```
$ nix-build nixos-2016-03/presentation.nix
```

フラグも渡せます:

```
$ nix-build nixos-2016-03/presentation.nix --arg style = \"dark\" --arg incremental false
```

結果は`result`フォルダーに作成され、コマンドで資料を`qutebroser`で開始できます

```
$ ./result/bin/meetup-2016-3
```

`pandoc`でも資料を生成できます、例

```
$ pandoc -s -t slidy nixos-2016-03/source.markdown -o index.html --css common-files/base.css --css common-files/light.css
$ firefox index.html
```

資料修正や追加にはお気軽にPull Requestかissueでお願いします！
