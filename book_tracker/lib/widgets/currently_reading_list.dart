import 'package:flutter/material.dart';

class CurrentlyReadingList extends StatelessWidget {
  const CurrentlyReadingList({
    Key key,
    @required this.books,
  }) : super(key: key);

  final List<String> books;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final src =
              'https://www.asme.org/getmedia/c2c8ea5a-b690-4ba7-92bb-34bd1432862b/book_guide_hero_books.png?width=300&height=315&ext=.png';
          return Container(
            padding: const EdgeInsets.all(1),
            height: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                trailing: Text('*'),
                title: Text('${books[index]}'),
                subtitle: Text('The best book I have ever read!'),
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(src),
                  child: Image.network(src),
                ),
                onTap: () {},
              ),
            ),
          );
        });
  }
}
