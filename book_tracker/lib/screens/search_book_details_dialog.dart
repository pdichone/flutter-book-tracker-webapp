import 'package:book_tracker/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedBookDetailDialog extends StatelessWidget {
  const SearchedBookDetailDialog({
    Key? key,
    required this.book,
    required CollectionReference collectionReference,
  })  : _collectionReference = collectionReference,
        super(key: key);

  final Book book;
  final CollectionReference _collectionReference;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage('${book.photoUrl}'),
                radius: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${book.title}',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category: ${book.categories}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Page Count: ${book.pageCount}'),
          ),
          Text('Author: ${book.author}'),
          Text('Published: ${book.publishedDate}'),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blueGrey.shade100, width: 1)),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${book.description}',
                      style: TextStyle(wordSpacing: 0.8, letterSpacing: 2),
                    ),
                  )),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              backgroundColor: Colors.amber,
              textStyle: TextStyle(fontSize: 18),
              onSurface: Colors.grey,
            ),
            onPressed: () {
              //save this new book to the list
              _collectionReference.add(Book(
                      userId: user.uid,
                      title: book.title,
                      author: book.author,
                      photoUrl: book.photoUrl,
                      publishedDate: book.publishedDate,
                      description: book.description,
                      pageCount: book.pageCount,
                      categories: book.categories)
                  .toMap());

              //Navigator.of(context).pop();
              //Navigator.pushNamed(context, '/main');

              Navigator.of(context).pop();
            },
            child: Text('Save this Book')),
        TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              backgroundColor: Colors.amber,
              textStyle: TextStyle(fontSize: 18),
              onSurface: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ],
    );
  }
}
