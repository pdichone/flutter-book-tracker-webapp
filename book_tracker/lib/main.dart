import 'dart:convert';

import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/book_view_model.dart';
import 'package:book_tracker/model/query_view_model.dart';
import 'package:book_tracker/page_zones/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'constants/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final linkCollection = FirebaseFirestore.instance.collection('books');
    final userBookDataStream = linkCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((book) {
        return Book.fromDocument(book);
      }).toList();
    });

    return MultiProvider(
      providers: [
        Provider<CollectionReference>(
          create: (context) => linkCollection,
        ),
        StreamProvider<List<Book>>(
          initialData: [],
          catchError: (context, error) {
            return [];
          },
          create: (context) => userBookDataStream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Tracker web app',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: MainPage(),
      ),
    );
  }

  // Future<List<Book>> fetchBooks(String query) async {
  //   var bookList = [];

  //   http.Response response = await http.get(Uri.parse(searchQuery(query)));
  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body);
  //     final Iterable list = body['items'];

  //     for (var item in list) {
  //       String title = item['volumeInfo']['title'];
  //       String author = item['volumeInfo']['authors'][0];
  //       String thumbNail = item['volumeInfo']['imageLinks']['thumbnail'];
  //       Book searchBook = new Book(title: title, author: author);

  //       bookList.add(searchBook);
  //     }

  //     return bookList;
  //   }
  // }
}
