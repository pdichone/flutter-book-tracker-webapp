import 'package:book_tracker/widgets/left_main_menu.dart';
import 'package:book_tracker/widgets/main_body_dashboard.dart';
import 'package:book_tracker/widgets/right_main_body.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> books = <String>[
      'Book 1',
      'Boo 2',
      'Book 3',
      'Boo 2',
      'Book 3'
    ];
    return Material(
      color: HexColor('#dee2ea'),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 45),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.transparent, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LeftMainMenu(),
            MainBodyDashboard(),
            RightMainBody(books: books)
          ],
        ),
      ),
    );
  }
}
