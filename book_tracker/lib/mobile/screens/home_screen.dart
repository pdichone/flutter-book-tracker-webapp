import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: Colors.green,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              )),
        ],
      ),
    );
  }
}
