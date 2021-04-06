import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/page_zones/main_page.dart';
import 'package:book_tracker/pages/book_details_page.dart';
import 'package:book_tracker/utils/utils.dart';
import 'package:book_tracker/widgets/create_profile.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class RightMainBody extends StatelessWidget {
  const RightMainBody({
    Key key,
    @required this.books,
  }) : super(key: key);

  final List<String> books;

  @override
  Widget build(BuildContext context) {
    final _books = Provider.of<List<Book>>(context);
    final _collectionReference = Provider.of<CollectionReference>(context);

    final authUser = Provider.of<User>(context);

    final userCollectionLink = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: _collectionReference.snapshots(),
      builder: (context, snapshot) {
        // print(snapshot.data.docs.first.data());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //Filter read books only!
        final userBookFilteredReadListStream = snapshot.data.docs.map((book) {
          return Book.fromDocument(book);
        }).where((book) {
          //only give us books that are being read, currently!
          return (book.startedReading != null) &&
              (book.finishedReading != null) &&
              (book.userId == authUser.uid);
        }).toList();
        return Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: HexColor('#f1f3f6'),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14))
                  //borderRadius: BorderRadius.all(Radius.circular(14))
                  ),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: userCollectionLink.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      //Filter read books only!
                      final usersListStream = snapshot.data.docs.map((mUser) {
                        // print("===> ${mUser.id} currAuth: ${authUser.uid}");
                        return MUser.fromDocument(mUser);
                      }).where((element) {
                        return (element.uid ==
                            authUser
                                .uid); //authuser must match one user in the list of users!
                      }).toList();

                      return usersListStream.isNotEmpty
                          ? SizedBox(
                              child: createProfile(
                                  context, usersListStream, authUser),
                            )
                          : Text('Nope');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Books Read (${userBookFilteredReadListStream.length})',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 2,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: userBookFilteredReadListStream
                              .length, //_books.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                tileColor: HexColor('#f1f3f6'),
                                title: Text(
                                    '${userBookFilteredReadListStream[index].title}'),
                                // title: Text('${books[index]}'),
                                subtitle: Text(
                                    'By: ${userBookFilteredReadListStream[index].author}'),

                                leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        (userBookFilteredReadListStream[index]
                                                    .photoUrl ==
                                                null)
                                            ? 'https://media.istockphoto.com/photos/ethnic-profile-picture-id185249635?k=6&m=185249635&s=612x612&w=0&h=8U5SlsY9iGJcHqBSxd_r6PLbgGFylccForDTK8drYcg='
                                            : userBookFilteredReadListStream[
                                                    index]
                                                .photoUrl,
                                      ),
                                      radius: 50,
                                    )),
                                trailing: Column(children: [
                                  Text(
                                    'Finished: ${formattDate(userBookFilteredReadListStream[index].finishedReading).toString().split(',')[0]}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 13),
                                  ),
                                  Icon((Icons.more_horiz_outlined))
                                ]),
                                onTap: () {
                                  //Go to book details on click
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailsPage(
                                          book: userBookFilteredReadListStream[
                                              index],
                                        ),
                                      ));
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
