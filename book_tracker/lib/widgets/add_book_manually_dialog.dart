import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookManually extends StatelessWidget {
  const AddBookManually({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(),
      icon: Icon(Icons.add),
      label: Text('Add a book'),
      onPressed: () {
        //Open an alert form dialog
        return showDialog(
            context: context,
            builder: (context) {
              TextEditingController _titleTextController =
                  TextEditingController();
              TextEditingController _authorTextController =
                  TextEditingController();
              TextEditingController _photoTextController =
                  TextEditingController();

              return AlertDialog(
                title: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter a book',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: _titleTextController,
                          decoration: buildInputDecoration(
                              'Book title', 'Gone with the Wind'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          //obscureText: true, //it's a password :)
                          controller: _authorTextController,
                          decoration:
                              buildInputDecoration("Author", 'Jeff Doe'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: _photoTextController,
                          decoration:
                              buildInputDecoration("Book cover link", ''),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            backgroundColor: Colors.amber,
                            textStyle: TextStyle(fontSize: 18),
                            onSurface: Colors.grey,
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('books').add(
                                Book(
                                        title: _titleTextController.text,
                                        author: _authorTextController.text,
                                        photoUrl: _photoTextController.text)
                                    .toMap());
                            Navigator.of(context).pop();
                          },
                          child: Text('Save')),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
