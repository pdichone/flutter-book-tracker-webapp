import 'dart:ui';

import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/mobile/screens/mobile_book_details.dart';

import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/utils/utils.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget? createProfileMobile(
    BuildContext context, List<MUser> list, User authUser, int booksRead) {
  TextEditingController _displayNameTextController =
      TextEditingController(text: list[0].displayName);
  TextEditingController _professionTextController =
      TextEditingController(text: list[0].profession);
  TextEditingController _avatarTextController =
      TextEditingController(text: list[0].avatarUrl);
  TextEditingController _quoteTextController =
      TextEditingController(text: list[0].quote);

  Widget? widget;

  CollectionReference books = FirebaseFirestore.instance.collection('books');

  for (var user in list) {
    widget = Container(
      color: Colors.white,
      //height: 100,
      margin: EdgeInsets.all(23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(user.avatarUrl == null
                      ? 'https://media.istockphoto.com/photos/ethnic-profile-picture-id185249635?k=6&m=185249635&s=612x612&w=0&h=8U5SlsY9iGJcHqBSxd_r6PLbgGFylccForDTK8drYcg='
                      : user.avatarUrl!),
                  radius: 50,
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 103),
                child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: kButtonColor,
                    ),
                    label: Text('')),
              )
            ],
          ),
          Text(
            'Books Read ($booksRead)',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.redAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${user.displayName!.toUpperCase()}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton.icon(
                  // style: TextButton.styleFrom(
                  //     primary: Colors.white,
                  //     backgroundColor: Colors.blueGrey.shade100),
                  icon: Icon(
                    Icons.mode_edit,
                    color: Colors.black12,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfile(
                            user: user,
                            displayNameTextController:
                                _displayNameTextController,
                            professionTextController: _professionTextController,
                            quoteTextController: _quoteTextController,
                            avatarTextController: _avatarTextController);
                      },
                    );
                  },
                  label: Text('')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${user.profession}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          SizedBox(
            width: 100,
            height: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 100,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.blueGrey.shade100,
                    ),
                    color: HexColor('#f1f3f6'),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text(
                        'Favorite Quote:',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: 100,
                        height: 2,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          (user.quote == null)
                              ? 'Favorite Book Quote : Life is great when you\'re not hungry...'
                              : " \"${user.quote} \"",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: books.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

//Filter read books only!
              final userBookFilteredReadListStream =
                  snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((book) {
                return (book.startedReading != null) &&
                    (book.finishedReading != null) &&
                    (book.userId == user.uid);
              }).toList();

              booksRead = userBookFilteredReadListStream.length;

              var curUserBookList = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((book) {
                //only give us books from current User that were read!
                return (book.userId == user.uid) &&
                    (book.startedReading != null &&
                        book.finishedReading != null);
              }).toList();
              return Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: curUserBookList.length,
                  itemBuilder: (context, index) {
                    Book book = curUserBookList[index];

                    // if (book.startedReading != null &&
                    //     book.finishedReading != null) {
                    //   btnText = 'Finished';
                    // } else if (book.startedReading != null &&
                    //     book.finishedReading == null) {
                    //   btnText = 'Reading';
                    // }
                    return Container(
                      child: Card(
                        elevation: 2.0,
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('${book.title}'),
                                leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(book.photoUrl!),
                                ),
                                subtitle: Text('${book.author}'),
                                isThreeLine: true,
                              ),
                              Text(
                                  'Finished: ${formattDate(book.finishedReading!)}')
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileBookDetailsPage(
                                        book: book,
                                      )),
                            );
                          },
                        ),
                      ),
                    );
                    // return ReadingListCard(
                    //   buttonText: btnText,
                    //   rating: book.rating != null ? book.rating : 4.6,
                    //   pressDetails: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) => MobileBookDetailsPage(
                    //         book: book,
                    //       ),
                    //     );
                    //     // Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(
                    //     //       builder: (context) => MobileBookDetailsPage(
                    //     //             book: book,
                    //     //           )),
                    //     // );
                    //   },
                    //   pressRead: () {
                    //     //print('Read');
                    //   },
                    //   auth: book.author,
                    //   image: book.photoUrl,
                    //   title: book.title,
                    // );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  return widget;
}

/*

Container(
          height: 100,
          width: 190,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              Book book = bookList[index];

              return ListTile(
                title: Text('${book.title}'),
              );

              //return Container(
              // width: 200,

              // child: Card(
              //   elevation: 2.0,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       ListTile(
              //         title: Text('${book.title}'),
              //         leading: CircleAvatar(
              //           radius: 35,
              //           backgroundImage: NetworkImage(book.photoUrl),
              //         ),
              //         subtitle: Text('${book.author}'),
              //       ),
              //       Text('Finished: ${formatDate(book.finishedReading)}')
              //     ],
              //   ),
              // ),
              // );
            },
          ),
        )
*/