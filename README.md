# cupertino_modal_sheet

[![pub package](https://img.shields.io/pub/v/cupertino_modal_sheet.svg)](https://pub.dartlang.org/packages/cupertino_modal_sheet)


**[English](https://github.com/zuvola/cupertino_modal_sheet/blob/master/README.md), [日本語](https://github.com/zuvola/cupertino_modal_sheet/blob/master/README_jp.md)**


Shows a modal iOS-style sheet that slides up from the bottom of the screen.  

On mobile devices, the content is displayed as a sheet, with part of the background content near the top of the screen.  
On tablet, a dimming layer is added to the background content and the content is centered over this layer.  

# Mobile

<img src="https://github.com/zuvola/cupertino_modal_sheet/blob/master/example/ss/mobile.gif?raw=true" width="320px"/>

# Tablet

<img src="https://github.com/zuvola/cupertino_modal_sheet/blob/master/example/ss/tablet.gif?raw=true" width="320px"/>


## Features

- Hero compatibility
- Tablet compatibility
- Swiping to dismiss
- Multi sheet (Dimming is imperfect)
- Navigator2 compatibility
  

## Getting started

```dart
showCupertinoModalSheet(
  context: context,
  builder: (context) => BookDetailsScreen(book: book),
);
```

## Navigator2.0

Use CupertinoModalSheetPage or directly CupertinoModalSheetRoute.


## TODO

- [ ] Tests
- [ ] Extensibility
- [ ] Fix dimming of multi-sheet

PRs are welcome!