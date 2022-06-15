import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BooksApp());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoModalSheetRoute(
              builder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return BooksListScreen(
                  books: books,
                  onTapped: (book) {
                    Navigator.of(context).push(CupertinoModalSheetRoute(
                      builder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return BookDetailsScreen(
                          book: book,
                          onPressed: () {
                            Navigator.of(context).push(CupertinoModalSheetRoute(
                              builder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return BookDetailsScreen(
                                  book: book,
                                );
                              },
                            ));
                          },
                        );
                      },
                    ));
                  },
                );
              },
            );
        }
      },
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
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            for (var book in books)
              ListTile(
                leading: Hero(
                    tag: book,
                    child: Container(
                      color: Colors.amber,
                      height: 50,
                      width: 50,
                    )),
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => onTapped(book),
              )
          ],
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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Hero(
                  tag: book,
                  child: Container(
                    color: Colors.amber,
                    height: 50,
                    width: 50,
                  )),
              Text(book.title, style: Theme.of(context).textTheme.headline6),
              Text(book.author, style: Theme.of(context).textTheme.subtitle1),
              ElevatedButton(onPressed: onPressed, child: const Text('button'))
            ],
          ],
        ),
      ),
    );
  }
}
