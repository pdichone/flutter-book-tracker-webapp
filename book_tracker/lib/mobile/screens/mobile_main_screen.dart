import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/mobile/screens/mobile_book_details.dart';
import 'package:book_tracker/mobile/screens/mobile_book_search.dart';
import 'package:book_tracker/mobile/widgets/mobile_create_profile.dart';
import 'package:book_tracker/mobile/widgets/reading_card_list.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/screens/getting_started_page.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/widgets/create_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileMainScreen extends StatelessWidget {
  const MobileMainScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    var user = Provider.of<User>(context);

    int booksRead = 0;
    final userCollectionLink = FirebaseFirestore.instance.collection('users');
    return WillPopScope(
      onWillPop: () async => false, //disable the back button!
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white24,
          toolbarHeight: 77,
          elevation: 0.0,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset(
                'assets/images/Icon-76.png',
                scale: 2,
              ),
              Text(
                'A.Reader',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // title: Text(
          //   'A.Reader',
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline5
          //       .copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
          // ),
          actions: [
            StreamBuilder<QuerySnapshot>(
                stream: userCollectionLink.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //Filter current user only!
                  final usersListStream = snapshot.data.docs.map((mUser) {
                    // print("===> ${mUser.id} currAuth: ${authUser.uid}");
                    return MUser.fromDocument(mUser);
                  }).where((element) {
                    return (element.uid ==
                        user.uid); //authuser must match one user in the list of users!
                  }).toList();

                  MUser curUser = usersListStream[0];
                  // print(curUser.id);

                  return Column(
                    children: [
                      CircleAvatar(
                        child: InkWell(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                curUser.avatarUrl != null
                                    ? curUser.avatarUrl
                                    : 'https://i.pravatar.cc/300'),
                            backgroundColor: Colors.white,
                            child: Text(''),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => createProfileMobile(
                                  context, usersListStream, user, booksRead),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          curUser.displayName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: kBlackColor),
                        ),
                      ),
                    ],
                  );
                }),
            TextButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.grey,
                ),
                label: Text(''))
          ],
        ),
        body: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              // padding: EdgeInsets.only(bottom: 12),
              // height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline5,
                          children: [
                            TextSpan(text: 'Your reading\n activity '),
                            TextSpan(
                                text: 'right now...',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: books.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

//Filter read books only!
                final userBookFilteredReadListStream =
                    snapshot.data.docs.map((book) {
                  return Book.fromDocument(book);
                }).where((book) {
                  return (book.startedReading != null) &&
                      (book.finishedReading != null) &&
                      (book.userId == user.uid);
                }).toList();

                booksRead = userBookFilteredReadListStream.length;

                var curUserBookList = snapshot.data.docs.map((book) {
                  return Book.fromDocument(book);
                }).where((book) {
                  //only give us books from current User!
                  return (book.userId == user.uid) &&
                      (book.startedReading != null &&
                          book.finishedReading == null);
                }).toList();

                // var sortedList = curUserBookList.w
                //curUserBookList = curUserBookList.reversed.toList();
                return Expanded(
                  flex: 1,
                  child: (curUserBookList.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: curUserBookList.length,
                          itemBuilder: (context, index) {
                            Book book = curUserBookList[index];
                            String btnText = '';
                            if (book.startedReading != null &&
                                book.finishedReading != null) {
                              btnText = 'Finished';
                            } else if (book.startedReading != null &&
                                book.finishedReading == null) {
                              btnText = 'Reading';
                            }

                            return InkWell(
                              child: ReadingListCard(
                                buttonText: btnText,
                                rating:
                                    book.rating != null ? (book.rating) : 4.0,
                                pressDetails: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => MobileBookDetailsPage(
                                      book: book,
                                    ),
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MobileBookDetailsPage(
                                  //             book: book,
                                  //           )),
                                  // );
                                },
                                pressRead: () {
                                  //print('Read');
                                },
                                auth: book.author,
                                image: book.photoUrl,
                                title: book.title,
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => MobileBookDetailsPage(
                                  book: book,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              'You haven\'t started reading. \nStart by adding a book',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ))),
                );
              },
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: "Reading List",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 8,
            ),
            //Reading list

            StreamBuilder<QuerySnapshot>(
              stream: books.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                var readingListBook = snapshot.data.docs.map((book) {
                  return Book.fromDocument(book);
                }).where((book) {
                  return (book.startedReading == null) &&
                      (book.finishedReading == null) &&
                      (book.userId == user.uid);
                }).toList();

                return Expanded(
                  flex: 1,
                  child: (readingListBook.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: readingListBook.length,
                          itemBuilder: (context, index) {
                            // final books = snapshot.data.docs.map((book) {
                            //   return Book.fromDocument(book);
                            // }).toList();

                            Book book = readingListBook[index];

                            return InkWell(
                              child: ReadingListCard(
                                buttonText: 'Not Started',
                                rating:
                                    book.rating != null ? (book.rating) : 4.0,
                                pressDetails: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => MobileBookDetailsPage(
                                      book: book,
                                    ),
                                  );
                                  // print(book.title);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MobileBookDetailsPage(
                                  //             book: book,
                                  //           )),
                                  // );
                                },
                                pressRead: () {
                                  //print('Read');
                                },
                                auth: book.author,
                                image: book.photoUrl,
                                title: book.title,
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => MobileBookDetailsPage(
                                  book: book,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No books found.  Add a Book :)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MobileBookSearchPage()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: kProgressIndicator,
        ),
      ),
    );
  }
}
