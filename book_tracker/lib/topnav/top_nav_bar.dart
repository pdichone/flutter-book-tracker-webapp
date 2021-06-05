import 'package:book_tracker/widgets/add_book_manually_dialog.dart';
import 'package:book_tracker/widgets/add_book_search.dart';

import 'package:flutter/material.dart';

class TopBarNav extends StatelessWidget {
  final String title;
  const TopBarNav({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: Theme.of(context).textTheme.headline3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [AddBookManually(), AddBookBySearch()],
          ),
        ],
      ),
    );
  }
}
