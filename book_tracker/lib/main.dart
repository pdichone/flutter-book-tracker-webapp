import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/page_zones/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    // filteredBooks = userBookDataStream.where((books) => books.forEach((book) {
    //       return book.startedReading != null;
    //     }));
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
}
