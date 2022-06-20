# cupertino_modal_sheet

[![pub package](https://img.shields.io/pub/v/cupertino_modal_sheet.svg)](https://pub.dartlang.org/packages/cupertino_modal_sheet)


**[English](https://github.com/zuvola/cupertino_modal_sheet/blob/master/README.md), [日本語](https://github.com/zuvola/cupertino_modal_sheet/blob/master/README_jp.md)**


画面下部からスライドアップするモーダルなiOS風シートを表示します。  

モバイルでは、コンテンツをシートとして表示し、画面の上部付近に背景コンテンツの一部が表示されます。  
タブレット端末では、背景のコンテンツに調光レイヤーを追加し、このレイヤーの上にコンテンツを中央に表示します。

# Mobile

<img src="https://github.com/zuvola/cupertino_modal_sheet/blob/master/example/ss/mobile.gif?raw=true" width="320px"/>

# Tablet

<img src="https://github.com/zuvola/cupertino_modal_sheet/blob/master/example/ss/tablet.gif?raw=true" width="320px"/>


## Features

- Heroをサポート
- Tabletでの表示
- スワイプでクローズ
- 複数シート (バリアの表示が不完全)
- Navigator2対応


## Getting started

```dart
showCupertinoModalSheet(
  context: context,
  builder: (context) => BookDetailsScreen(book: book),
);
```

## Navigator2.0

CupertinoModalSheetPageか直接CupertinoModalSheetRouteを使ってください。


## TODO

- [ ] テスト
- [ ] 拡張性
- [ ] 複数シートのバリア修正

PRは大歓迎です！