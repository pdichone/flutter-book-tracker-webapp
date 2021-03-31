import 'dart:convert';

import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/book_view_model.dart';
import 'package:book_tracker/model/query_view_model.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  List<Book> listOfBooks = [];
  String _searchVal;
  TextEditingController _searchTextController;
  bool listIsFull = false;

  @override
  void initState() {
    super.initState();
    // listOfBooks = [];

    _searchTextController = TextEditingController();

    // sync the current value in text field to
    // the view model
    // _searchTextController.addListener(() {
    //   Provider.of<QueryEntryViewModel>(context, listen: false)
    //       .updateQuery(_searchTextController.text);
    // });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http.get(Uri.parse(searchQuery(query)));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];

      for (var item in list) {
        String title = item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'][0];
        String thumbNail = item['volumeInfo']['imageLinks']['smallThumbnail'];
        Book searchBook =
            new Book(title: title, author: author, photoUrl: thumbNail);

        books.add(searchBook);

        // print('${item['volumeInfo']['title']}');
        //print('${item['volumeInfo']['authors']}');

      }

      print('Length --> ${books.length}');
    }
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
        foregroundColor: Colors.red,
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(children: [
              Container(
                child: Material(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(19),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: TextField(
                          onSubmitted: (value) {
                            _search();
                            // setState(() {
                            // _searchVal = value;

                            // });
                            //listOfBooks.clear();
                          },
                          controller: _searchTextController,
                          decoration: buildInputDecoration(
                              'Search', 'Gone with the Wind'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              (listOfBooks.length > 0 &&
                      listOfBooks.length < 50) //limit to 50 only
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listOfBooks.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children:
                                      createBookCards(listOfBooks, context),
                                );

                                //return Text('${listOfBooks[index].title}');
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : CircularProgressIndicator()
              //Text('${listo}')

              //updateBookList(_searchVal)
            ])),
      ),
    );
  }

  Widget updateBookList(String query) {
    print('Calling UpdateLIst');
    return FutureBuilder<List<Book>>(
      future: fetchBooks(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          //we are good!
          print('Inside ==> ${snapshot.data}');
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshot.data[0].title),
                )
              ],
            ),
          );
        }
      },
    );
  }

  void _search() async {
    final List<Book> books = await fetchBooks(_searchTextController.text);
    setState(() {
      listOfBooks = books;
      listIsFull = true;
    });
  }

  List<Widget> createBookCards(List<Book> books, BuildContext context) {
    List<Widget> children = [];

    for (var book in books) {
      children.add(
        new Container(
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              //color: HexColor('#5d48b6'),
              //border: Border.all(width: 5),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Card(
            elevation: 5,
            color: HexColor('#f6f4ff'),
            child: Wrap(
              children: [
                Image.network(
                  //'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1950&q=80',
                  (book.photoUrl == null || book.photoUrl.isEmpty)
                      ? 'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1950&q=80'
                      : book.photoUrl,
                  //fit: BoxFit.cover,
                  height: 100,
                  width: 160,
                ),
                ListTile(
                  title: Text(
                    '${book.title}',
                    style: TextStyle(color: HexColor('#5d48b6')),
                  ),
                  subtitle: Text('${book.author}'),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => BookDetailsPage(
                    //         book: book,
                    //       ),
                    //     ));
                  },
                )
              ],
            ),
          ),
        ),
      );
    }
    return children;
  }
}

// TextEditingController _searchTextController = TextEditingController();
// final _books = Provider.of<List<Book>>(context);

// return Consumer<QueryEntryViewModel>(
//   builder: (context, model, child) {
//     return Material(
//       elevation: 3,
//       child: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 model.updateQuery(_searchTextController.text);
//                 model.refreshBooks(_searchTextController.text, context);
//               },
//             ),
//             SizedBox(
//               width: 12,
//             ),
//             Expanded(
//                 child: TextField(
//               controller: _searchTextController,
//               decoration: buildInputDecoration(
//                   'Enter query', 'Gone with the wind..'),
//               onSubmitted: (String query) {
//                 model.refreshBooks(query, context);
//               },
//             )),
//             Column(
//               children: [
//                 Consumer<BookViewModel>(builder: (context, value, child) {
//                   Future<List<Book>> books =
//                       value.getRecentBookSearch(_searchTextController.text);

//                   books.then((value) {
//                     for (var item in value) {
//                       print('${item.title}');
//                     }
//                   });
//                   return Text("hey");
//                 }),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );
