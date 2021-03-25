import 'package:book_tracker/views/main_body.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Tracker web apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Book Tracker",
          style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton.icon(
              label: Text('Login'),
              icon: Icon(Icons.login_rounded),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Social Buttons
          MainBody(),

          // Body
        ],
      ),
    );
  }
}
