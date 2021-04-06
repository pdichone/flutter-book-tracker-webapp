import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/pages/book_details_page.dart';
import 'package:book_tracker/topnav/top_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MainBodyDashboard extends StatelessWidget {
  const MainBodyDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _collectionReference = Provider.of<CollectionReference>(context);
    final user = Provider.of<User>(context);

    // List<String> readingList = [
    //   'Think Again',
    //   'Be again,',
    //   'Show Your Work',
    //   'Psychology of Money',
    //   'The History of Humankind',
    //   'Everyday Millionaires'
    // ];
    return Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TopBarNav(
              title: 'Dashboard',
            ),
            SizedBox(
              width: 100,
              height: 2,
              child: Container(
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 90,
            ),
            SizedBox(
              child: Text(
                'Currently Reading',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30.0),
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: _collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //Filter 'reading' books!!
                  final userBookFilteredDataStream =
                      snapshot.data.docs.map((book) {
                    return Book.fromDocument(book);
                  }).where((book) {
                    //only give us books that are being read, currently!
                    return (book.startedReading != null) &&
                        (book.finishedReading == null) &&
                        (book.userId == user.uid);
                  }).toList();

                  return userBookFilteredDataStream.isNotEmpty
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: createBookCards(
                              userBookFilteredDataStream, context, user))
                      : Center(
                          child: Text(
                          'You\'re not reading any books :( add a book and get started.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ));
                },
              ),
            ),

            // ** Reading List ***
            SizedBox(
              child: Text(
                'Reading List',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: MediaQuery.of(context).size.height * 0.2,
              child: StreamBuilder<QuerySnapshot>(
                stream: _collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  //Filter to show only books that haven't been started and finished
                  //Filter 'reading' books!!
                  final userBookFilteredReadingListStream =
                      snapshot.data.docs.map((book) {
                    return Book.fromDocument(book);
                  }).where((book) {
                    //only give us books that are being read, currently!
                    return (book.startedReading == null) &&
                        (book.finishedReading == null) &&
                        (book.userId == user.uid);
                  });
                  return userBookFilteredReadingListStream.isNotEmpty
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: createBookCards(
                              userBookFilteredReadingListStream.toList(),
                              context,
                              user))
                      : Center(
                          child: Text(
                            'Your book list is empty.  Add a book to get started.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        );
                },
              ),
            )
          ],
        ));
  }

  List<Widget> createBookCards(
      List<Book> books, BuildContext context, User user) {
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
                // Image.network(book.photoUrl == null
                //     ? 'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1950&q=80'
                //     : book.photoUrl),
                ListTile(
                  title: Text(
                    '${book.title}',
                    style: TextStyle(color: HexColor('#5d48b6')),
                  ),
                  subtitle: Text('${book.author}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(
                            book: book,
                          ),
                        ));
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
