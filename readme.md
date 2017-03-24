# 東京Nixosミートアップ勉強会資料

[Tokyo Nixos Meetup](http://www.meetup.com/ja-JP/Tokyo-NixOS-Meetup/)に紹介された資料を集めるレポジトリです。


## 資料一覧

### 2017年

- 3月: [Hydra](2017/03/source.markdown)
- 3月（オープンソースカンファレンス）: [NixOSの基本 ― 開発と運用管理に特化したLinuxの紹介 ―](2017/03-osc/source.markdown)
- 2月: [Managing projects with Nix](2017/02/source.markdown)
- 1月: [Packaging](2017/01/source.markdown)


### 2016年

- 12月: [NixOS First Steps](2016/12/source.markdown)
- 11月: [NixOS Install](2016/11/source.markdown)
- 11月（オープンソースカンファレンス）: [関数型デプロイメント: Nixエコシステムの紹介](2016/11-osc/source.markdown)
- 10月: [NixOS 16.09 Release](2016/10-release/source.markdown)
- 9月: [Extended Types for NixOS Modules](2016/09/source.markdown)
- 8月(一周年記念イベント): [1 year anniversary](2016/08-1-year/source.markdown)
- 8月: [Hydra](2016/08/source.markdown)
- 7月: 休み
- 6月: [nixpkgs](2016/06/source.markdown)
- 5月: [ハンズオン](2016/05/source.markdown)
- 4月(Wakame User Group): [Nixエコシステムの紹介](2016/04-wug/source.markdown)
- 4月: [Nix言語](2016/04/source.markdown) ([英語](2016/04/source.en.markdown))
- 3月: [NixOps & Nix DevOps](2016/03/source.markdown)
- 2月(オープンソースカンファレンス): [関数型Linux: NixOSの仕組みと特徴の紹介](2016/02-osc/source.markdown)
- 2月: [Packaging 101](2016/02/source.markdown) (英語)


### 2015年

- 9月: [NixOS Basics](2015/09/source.markdown) (英語)


## ビルド

### Nix (NixOS、Nix)

Nixで各資料をビルドできます、例:

```
$ nix-build YYYY/MM
```

引数も指定できます:

```
$ nix-build YYYY/MM --argstr style dark --arg incremental false
```

結果は`result`フォルダーに作成され、コマンドで資料を`qutebrowser`で開始できます

```
$ ./result/bin/meetup-YYYY-MM
```

### Pandoc

`pandoc`でも資料を生成できます、例

```
$ pandoc -s -t slidy YYYY/MM/source.markdown -o index.html --css common-files/base.css --css common-files/light.css
$ firefox index.html
```


## ファイル一覧

- `mkPresentation.nix`: プレゼンテーションを生成するNix Expression
- `common-files`: プレゼンテーションで使うCSSと画像
- `YYYY`: 書く勉強会のソース資料、`source.mardown`はgithubでも見れます


---

資料修正や追加はお気軽にPull Requestかissueでお願いします！
