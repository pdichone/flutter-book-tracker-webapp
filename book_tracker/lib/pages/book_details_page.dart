import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/page_zones/main_page.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({Key key, this.book}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool isReadingClicked = false;
  bool isFinishedRadingClicked = false;

  @override
  Widget build(BuildContext context) {
    final _collectionReference = Provider.of<CollectionReference>(context);
    final user = Provider.of<User>(context);

    TextEditingController _titleTextController =
        TextEditingController(text: widget.book.title);
    TextEditingController _authorTextController =
        TextEditingController(text: widget.book.author);
    TextEditingController _photoTextController =
        TextEditingController(text: widget.book.photoUrl);
    TextEditingController _notesTextController =
        TextEditingController(text: widget.book.notes);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        foregroundColor: Colors.red,
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: Material(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage('${widget.book.photoUrl}'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                            onPressed: widget.book.startedReading == null
                                ? () {
                                    //capture the timestamp (date) and update startDate field
                                    setState(() {
                                      if (isReadingClicked == false) {
                                        isReadingClicked = true;
                                      } else {
                                        isReadingClicked = false;
                                      }
                                    });
                                  }
                                : null,
                            icon: Icon(Icons.book_sharp),
                            label: (widget.book.startedReading == null)
                                ? (!isReadingClicked)
                                    ? Text('Start Reading this Book')
                                    : Text(
                                        'Started Reading...',
                                        style: TextStyle(
                                            color: Colors.grey.shade300),
                                      )
                                : Text(
                                    "Started on: ${formattDate(widget.book.startedReading)}")),
                        TextButton.icon(
                            onPressed: widget.book.finishedReading == null
                                ? () {
                                    //capture the timestamp (date) and update endDate field
                                    setState(() {
                                      if (isFinishedRadingClicked == false) {
                                        isFinishedRadingClicked = true;
                                      } else {
                                        isFinishedRadingClicked = false;
                                      }
                                    });
                                  }
                                : null,
                            icon: Icon(Icons.add),
                            label: (widget.book.finishedReading == null)
                                ? (!isFinishedRadingClicked)
                                    ? Text(
                                        'Mark as Read',
                                      )
                                    : Text('Finished Reading!',
                                        style: TextStyle(color: Colors.grey))
                                : Text(
                                    "Finished on ${formattDate(widget.book.finishedReading)}")),
                      ],
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                              // Only update if new data was entered
                              final userChangedTitle = widget.book.title !=
                                  _titleTextController.text;
                              final userChangedAuthor = widget.book.author !=
                                  _authorTextController.text;
                              final userChangedPhotoUrl = widget.book.author !=
                                  _photoTextController.text;

                              final userChangedNotes = widget.book.notes !=
                                  _notesTextController.text;

                              final bookUpdate = userChangedTitle ||
                                  userChangedAuthor ||
                                  userChangedPhotoUrl ||
                                  userChangedNotes;

                              // print('user changed notes $userChangedNotes');

                              if (bookUpdate) {
                                _collectionReference.doc(widget.book.id).update(
                                    Book(
                                            userId: user.uid,
                                            title: _titleTextController.text,
                                            author: _authorTextController.text,
                                            photoUrl: _photoTextController.text,
                                            startedReading: isReadingClicked
                                                ? Timestamp.now()
                                                : widget.book.startedReading,
                                            finishedReading:
                                                isFinishedRadingClicked
                                                    ? Timestamp.now()
                                                    : widget
                                                        .book.finishedReading,
                                            notes: _notesTextController.text)
                                        .toMap());
                              }

                              Navigator.of(context).pop();
                            },
                            child: Text('Update')),
                        IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Once the book is deleted you can\'t retrieve it back'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            // delete!
                                            _collectionReference
                                                .doc(widget.book.id)
                                                .delete();
                                            //go back to main page
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage(),
                                                ));
                                          },
                                          child: Text('Yes')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'))
                                    ],
                                  );
                                },
                              );
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formattDate(Timestamp timestamp) {
    return DateFormat.yMMMd().format(timestamp.toDate());
  }
}
