import 'package:book_tracker/views/footer.dart';
import 'package:book_tracker/widgets/currently_reading_list.dart';
import 'package:flutter/material.dart';

class MainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> books = <String>[
      'Book 1',
      'Boo 2',
      'Book 3',
      'Boo 2',
      'Book 3'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Welcome, Paulo',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'A book about Tathaji',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Text(
                      'Currently reading...',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: CurrentlyReadingList(books: books),
                  ),
                ],
              ),
            )),
        const SizedBox(
          width: 60,
        ),
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Add a book'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Colors.amber,
                      textStyle: TextStyle(fontSize: 18),
                      onSurface: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Favorite Book Passages'),
                SizedBox(
                  height: 5,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  elevation: 10,
                  color: Colors.white,
                  child: Text(
                      'Anything you want you can have.  That is all there is'),
                )
              ],
            ))
          ],
        ))
      ],
    );
  }
}
