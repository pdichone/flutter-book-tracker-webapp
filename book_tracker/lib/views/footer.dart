import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Made by All",
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(
            width: 8,
          ),
          Icon(
            Icons.ac_unit,
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}
