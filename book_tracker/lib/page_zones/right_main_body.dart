import 'package:book_tracker/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RightMainBody extends StatelessWidget {
  const RightMainBody({
    Key key,
    @required this.books,
  }) : super(key: key);

  final List<String> books;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        // print(snapshot.data.docs.first.data());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //convert books into Book objects
        final books = snapshot.data.docs.map((book) {
          return Book.fromMap(book.data());
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
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                          'https://media.istockphoto.com/photos/ethnic-profile-picture-id185249635?k=6&m=185249635&s=612x612&w=0&h=8U5SlsY9iGJcHqBSxd_r6PLbgGFylccForDTK8drYcg='),
                      radius: 50,
                    ),
                  ),
                  Text(
                    'Danny Devoe',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Business Analyst & Reader',
                      style: Theme.of(context).textTheme.overline,
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
                    padding: const EdgeInsets.all(48.0),
                    child: SizedBox(
                      height: 100,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.blueGrey.shade100,
                            ),
                            color: HexColor('#f1f3f6'),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        child: Center(
                            child: Text(
                          'Favorite Book Quote : Life is great when you\'re not hungry...',
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Books Read',
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
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                tileColor: HexColor('#f1f3f6'),
                                title: Text('${books[index].title}'),
                                // title: Text('${books[index]}'),
                                subtitle: Text('By: ${books[index].author}'),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: HexColor('#5d48b6'),
                                      //border: Border.all(width: 5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Text(
                                    '89%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  )),
                                ),
                                trailing: Icon((Icons.more_vert)),
                                onTap: () {},
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
