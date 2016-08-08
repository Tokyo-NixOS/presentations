# 東京Nixosミートアップ勉強会資料

[Tokyo Nixos Meetup](http://www.meetup.com/ja-JP/Tokyo-NixOS-Meetup/)に紹介された資料を集めるレポジトリです。


## 資料一覧

### 2016年

- 8月: [Hydra](nixos-2016-08/source.markdown)
- 7月: 休み
- 6月: [nixpkgs](nixos-2016-06/source.markdown)
- 5月: [ハンズオン](nixos-2016-05/source.markdown)
- 4月(Wakame User Group): [Nixエコシステムの紹介](nixos-2016-04-wug/source.markdown)
- 4月: [Nix言語](nixos-2016-04/source.markdown) ([英語](nixos-2016-04/source.en.markdown))
- 3月: [NixOps & Nix DevOps](nixos-2016-03/source.markdown)
- 2月(オープンソースカンファレンス): [関数型Linux: NixOSの仕組みと特徴の紹介](nixos-2016-02-osc/source.markdown)
- 2月: [Packaging 101](nixos-2016-02/source.markdown) (英語)


### 2015年

- 9月: [NixOS Basics](nixos-2015-09/source.markdown) (英語)


## ビルド

### Nix (NixOS、Nix)

Nixで各資料をビルドできます、例:

```
$ nix-build nixos-YYYY-MM
```

引数も指定できます:

```
$ nix-build nixos-YYYY-MM --argstr style dark --arg incremental false
```

結果は`result`フォルダーに作成され、コマンドで資料を`qutebrowser`で開始できます

```
$ ./result/bin/meetup-YYYY-MM
```

### Pandoc

`pandoc`でも資料を生成できます、例

```
$ pandoc -s -t slidy nixos-2016-03/source.markdown -o index.html --css common-files/base.css --css common-files/light.css
$ firefox index.html
```


## ファイル一覧

- `mkPresentation.nix`: プレゼンテーションを生成するNix Expression
- `common-files`: プレゼンテーションで使うCSSと画像
- `nixos-*`: 書く勉強会のソース資料、`source.mardown`はgithubでも見れます


---

資料修正や追加はお気軽にPull Requestかissueでお願いします！
