import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BooksApp());
}

class Book {
  final String title;
  final String author;
  final Color color;

  Book(this.title, this.author, this.color);
}

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin', Colors.red),
    Book('Too Like the Lightning', 'Ada Palmer', Colors.green),
    Book('Kindred', 'Octavia E. Butler', Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoModalSheetRoute(
              settings: settings,
              builder: (BuildContext context) {
                return BooksListScreen(
                  books: books,
                  onTapped: (book) {
                    _showDetails(context, book, (context) {
                      _showDetails(context, book, (context) {
                        _showDetails(context, book, (context) {
                          _showDetailsOnNestedNavigator(context, book,
                              (context) {
                            _pushDetails(context, book, (context) {
                              _pushDetails(context, book, (context) {
                                _showDetails(context, book, null);
                              });
                            });
                          });
                        });
                      });
                    });
                  },
                );
              },
            );
        }
        return null;
      },
    );
  }

  void _showDetails(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    showCupertinoModalSheet(
      context: context,
      builder: (context) => BookDetailsScreen(
        book: book,
        onPressed: onPressed == null ? null : () => onPressed(context),
      ),
    );
  }

  void _pushDetails(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: ((context) => BookDetailsScreen(
              book: book,
              onPressed: () => onPressed?.call(context),
            ))));
  }

  void _showDetailsOnNestedNavigator(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    final nav = Navigator(
      observers: [HeroController()],
      onGenerateRoute: (settings) => CupertinoPageRoute(
        builder: ((context) {
          return BookDetailsScreen(
            book: book,
            onPressed: () => onPressed?.call(context),
          );
        }),
      ),
    );
    showCupertinoModalSheet(
      context: context,
      builder: (context) => nav,
    );
  }
}

class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  const BooksListScreen({
    Key? key,
    required this.books,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text('Book List'),
      ),
      child: SafeArea(
        child: Material(
          child: ListView(
            children: [
              for (var book in books)
                ListTile(
                  leading: Hero(
                    tag: book,
                    child: Container(color: book.color, height: 50, width: 50),
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () => onTapped(book),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final Function()? onPressed;

  const BookDetailsScreen({
    Key? key,
    required this.book,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(book.title),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                    tag: book,
                    child: Container(
                      color: book.color,
                      height: 50,
                      width: 50,
                    )),
                Text(book.title, style: Theme.of(context).textTheme.titleLarge),
                Text(book.author,
                    style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton(onPressed: onPressed, child: const Text('next')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
