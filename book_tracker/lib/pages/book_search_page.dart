import 'dart:convert';

import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
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

  Future<void> fetchBooks(String query) async {
    http.Response response = await http.get(Uri.parse(searchQuery(query)));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];

      for (var item in list) {
        String title = item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'][0];
        String thumbNail = item['volumeInfo']['imageLinks']['thumbnail'];
        Book searchBook = new Book(title: title, author: author);

        listOfBooks.add(searchBook);

        // print('${item['volumeInfo']['title']}');
        //print('${item['volumeInfo']['authors']}');
      }

      print(listOfBooks);
    }
  }

  @override
  void initState() {
    super.initState();
    //listOfBooks.clear();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController _searchTextController = TextEditingController();
    final _books = Provider.of<List<Book>>(context);

    //_books.clear();

    //_books.addAll(listOfBooks);

    final _collectionReference = Provider.of<CollectionReference>(context);
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
                            setState(() {
                              _searchVal = value;
                              print(_searchVal);
                              print('new state! ${listOfBooks.length}');
                              fetchBooks(_searchVal);
                              _searchTextController.text = '';
                            });
                            listOfBooks.clear();
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

              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: listOfBooks.length,
                    itemBuilder: (context, index) {
                      if (listOfBooks.isEmpty || listOfBooks == null) {
                        return CircularProgressIndicator();
                      } else {
                        return ListTile(
                          title: Text('${listOfBooks[index].title}'),
                        );
                      }
                    },
                  ),
                ),
              )
              // Container(
              //   child: FutureBuilder<List<Book>>(
              //     future: fetchBooks(_searchVal),
              //     builder: (context, snapshot) {
              //       if (snapshot.data == null) {
              //         return CircularProgressIndicator();
              //       } else {
              //         return Expanded(
              //           child: ListView.builder(
              //             itemCount: snapshot.data.length,
              //             scrollDirection: Axis.horizontal,
              //             itemBuilder: (context, index) {
              //               return ListTile(
              //                 title: Text(snapshot.data[index].author),
              //                 subtitle: Text('Hello'),
              //               );
              //             },
              //           ),
              //         );
              //       }
              //     },
              //   ),
              // )

              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 30.0),
              //   height: 190,
              //   child: StreamBuilder<QuerySnapshot>(
              //     stream: _collectionReference.snapshots(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }

              //       return ListView(
              //           scrollDirection: Axis.horizontal,
              //           children: createBookCards(_books, context));
              //     },
              //   ),
              // )
            ])),
      ),
    );
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
