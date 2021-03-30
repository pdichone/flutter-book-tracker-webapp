import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key key, this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _collectionReference = Provider.of<CollectionReference>(context);

    TextEditingController _titleTextController =
        TextEditingController(text: book.title);
    TextEditingController _authorTextController =
        TextEditingController(text: book.author);
    TextEditingController _photoTextController =
        TextEditingController(text: book.photoUrl);
    TextEditingController _notesTextController =
        TextEditingController(text: book.notes);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        foregroundColor: Colors.red,
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: 
          Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Material(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage('${book.photoUrl}'),
                        radius: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _titleTextController,
                        decoration: buildInputDecoration(
                            'Book title', 'Gone with the Wind'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        //obscureText: true, //it's a password :)
                        controller: _authorTextController,
                        decoration: buildInputDecoration("Author", 'Jeff Doe'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _photoTextController,
                        decoration: buildInputDecoration("Book cover link", ''),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.date_range),
                        label: Text('Start Reading this Book')),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          maxLines: 5,
                          controller: _notesTextController,
                          decoration: buildInputDecoration(
                              "Your thoughts", 'Enter notes'),
                        )),
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
                          _collectionReference.doc(book.id).update(Book(
                                  title: _titleTextController.text,
                                  author: _authorTextController.text,
                                  photoUrl: _photoTextController.text,
                                  notes: _notesTextController.text)
                              .toMap());
                          Navigator.of(context).pop();
                        },
                        child: Text('Update')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
