import 'package:flutter/material.dart';

class MainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Paulo',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 100,
                ),
                Text('Currently reading...'),
              ],
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
          ],
        ))
      ],
    );
  }
}
