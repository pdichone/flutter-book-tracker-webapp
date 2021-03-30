import 'package:book_tracker/pages/book_search_page.dart';
import 'package:flutter/material.dart';

class AddBookBySearch extends StatelessWidget {
  const AddBookBySearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextButton.icon(
        style: ButtonStyle(),
        icon: Icon(Icons.search),
        label: Text('Add a book (Search)'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSearchPage(),
              ));
        },
      ),
    );
  }
}
