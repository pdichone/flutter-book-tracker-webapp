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
      children: [],
    );
  }
}
