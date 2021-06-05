import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    return MaterialApp(
      title: '',
      home: Scaffold(
        appBar: AppBar(
          actions: [
            CircleAvatar(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Image.network('https://i.pravatar.cc/300'),
              ),
            )
          ],
        ),
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
          stream: books.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> info = document.data() as Map<String, dynamic>;

                print(" ==>>${info['photo_url']}");
                return new ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: (info['photo_url'] != null)
                        ? Image.network(info['photo_url'])
                        : Image.network('https://i.pravatar.cc/300'),
                  ),
                  title: new Text(info['title']),
                  subtitle: new Text(info['author']),
                );
              }).toList(),
            );

            // return ListView(
            //   children: snapshot.data.docs.map((DocumentSnapshot document) {
            //     print(" ==>>${document.data()['photo_url']}");
            //     return new ListTile(
            //       leading: CircleAvatar(
            //         radius: 40,
            //         backgroundColor: Colors.green,
            //         child: (document.data()['photo_url'] != null)
            //             ? Image.network(document.data()['photo_url'])
            //             : Image.network('https://i.pravatar.cc/300'),
            //       ),
            //       title: new Text(document.data()['title']),
            //       subtitle: new Text(document.data()['author']),
            //     );
            //   }).toList(),
            // );
          },
        )),
      ),
    );
  }
}
