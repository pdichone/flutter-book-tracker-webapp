import 'dart:convert';

import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/book_view_model.dart';
import 'package:book_tracker/model/query_view_model.dart';
import 'package:book_tracker/pages/search_book_details_dialog.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  List<Book> listOfBooks = [];

  TextEditingController _searchTextController;
  bool listIsFull = false;

  @override
  void initState() {
    super.initState();

    _searchTextController = TextEditingController();
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http.get(Uri.parse(searchQuery(query)));
    String test = response.request.url.toString();
    print(test);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var list = body['items'];
      // final Iterable list = body['items'];
      print('Items ==> ${list.toString()}');

      for (var item in list) {
        String title = item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'] == null
            ? "N/A"
            : item['volumeInfo']['authors'][0];
        String thumbNail = (item['volumeInfo']['imageLinks'] == null)
            ? ""
            : item['volumeInfo']['imageLinks']['thumbnail'];
        String publishedDate = item['volumeInfo']['publishedDate'] == null
            ? "N/A"
            : item['volumeInfo']['publishedDate'];
        String description = item['volumeInfo']['description'] == null
            ? "N/A"
            : item['volumeInfo']['description'];
        int pageCount = item['volumeInfo']['pageCount'] == null
            ? 0
            : item['volumeInfo']['pageCount'];
        String categories = item['volumeInfo']['categories'] == null
            ? "N/A"
            : item['volumeInfo']['categories'][0];

        /* 
        or... run in: flutter run -d chrome --web-renderer html
        or.. change luancher.json:https://github.com/LunaGao/flag_flutter/issues/49#issuecomment-803008314
        to render images run web-renderer: https://stackoverflow.com/questions/66060984/flutter-web-image-loading-in-mobile-view-but-not-in-full-view */

        Book searchBook = new Book(
            title: title,
            author: author,
            photoUrl: thumbNail,
            publishedDate: publishedDate,
            description: description,
            pageCount: pageCount,
            categories: categories);

        books.add(searchBook);
      }
      print('Size ==> ${books.length}');
    } else {
      throw ('error ${response.reasonPhrase}');
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
              SizedBox(
                height: 10,
              ),
              (listOfBooks != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 300,
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: createBookCards(listOfBooks, context),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('No books found'),
                    )
            ])),
      ),
    );
  }

  void _search() async {
    await fetchBooks(_searchTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
        //print('SetState size ==> ${listOfBooks.length}');
        listIsFull = true;
      });
    }, onError: (val) {
      throw Exception('Failed to load books ${val.toString()}');
    });
  }

  List<Widget> createBookCards(List<Book> books, BuildContext context) {
    final _collectionReference = Provider.of<CollectionReference>(context);

    List<Widget> children = [];

    for (var book in books) {
      children.add(
        Container(
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
                      //: book.photoUrl,
                      : 'https://picsum.photos/900/600',
                  //fit: BoxFit.cover,
                  height: 100,
                  width: 160,
                ),
                ListTile(
                  title: Text(
                    '${book.title}',
                    style: TextStyle(
                      color: HexColor('#5d48b6'),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${book.author}',
                    // overflow: TextOverflow.ellipsis
                  ),
                  onTap: () {
                    //show book details popup
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SearchedBookDetailDialog(
                            book: book,
                            collectionReference: _collectionReference);
                      },
                    );
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
