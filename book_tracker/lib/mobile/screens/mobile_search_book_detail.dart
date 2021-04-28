import 'package:book_tracker/mobile/widgets/two_sided_rounded_button.dart';
import 'package:book_tracker/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/constants/constants.dart';

class MobileSearchedBookDetailDialog extends StatelessWidget {
  const MobileSearchedBookDetailDialog({
    Key key,
    @required this.book,
    @required CollectionReference collectionReference,
  })  : _collectionReference = collectionReference,
        super(key: key);

  final Book book;
  final CollectionReference _collectionReference;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.max,
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
                  .headline4
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
              width: MediaQuery.of(context).size.width * 0.99,
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
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TwoSideRoundedButton(
              color: kButtonColor,
              radious: 12,
              text: 'Save',
              press: () {
                //save this new book to the list
                _collectionReference.add(Book(
                        userId: user.uid,
                        // userId: '1Scrgn0JyiXqkzPRFmkHP9oBwB73',
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
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TwoSideRoundedButton(
              color: kButtonColor,
              radious: 12,
              text: 'Cancel',
              press: () {
                Navigator.of(context).pop();
              }),
        )
      ],
    );
  }
}
