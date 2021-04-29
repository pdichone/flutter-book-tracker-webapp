import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/main.dart';
import 'package:book_tracker/mobile/screens/mobile_main_screen.dart';
import 'package:book_tracker/mobile/widgets/two_sided_rounded_button.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/widgets/main_page.dart';
import 'package:book_tracker/utils/utils.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MobileBookDetailsPage extends StatefulWidget {
  final Book book;

  const MobileBookDetailsPage({Key key, this.book}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<MobileBookDetailsPage> {
  bool isReadingClicked = false;
  bool isFinishedRadingClicked = false;

  double _rating;

  @override
  Widget build(BuildContext context) {
    //final _linkCollection = Provider.of<CollectionReference>(context);
    final _linkCollection = FirebaseFirestore.instance.collection('books');
    final user = Provider.of<User>(context);

    TextEditingController _titleTextController =
        TextEditingController(text: widget.book.title);
    TextEditingController _authorTextController =
        TextEditingController(text: widget.book.author);
    TextEditingController _photoTextController =
        TextEditingController(text: widget.book.photoUrl);
    TextEditingController _notesTextController =
        TextEditingController(text: widget.book.notes);
    return AlertDialog(
      title: Column(mainAxisSize: MainAxisSize.max, children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage('${widget.book.photoUrl}'),
                radius: 50,
              ),
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 103),
              child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: kButtonColor,
                  ),
                  label: Text('')),
            )
          ],
        ),
        Text('${widget.book.author}'),
      ]),
      content: Form(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.blueGrey.withAlpha(18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _titleTextController,
                  decoration:
                      buildInputDecoration('Book title', 'Gone with the Wind'),
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
                height: 3,
              ),
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
                          ? Text('Start Reading')
                          : Text(
                              'Started Reading...',
                              style: TextStyle(color: Colors.grey.shade300),
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
                  icon: Icon(
                    Icons.done,
                    color: Colors.greenAccent,
                  ),
                  label: (widget.book.finishedReading == null)
                      ? (!isFinishedRadingClicked)
                          ? Text(
                              'Mark as Read',
                            )
                          : Text('Finished Reading!',
                              style: TextStyle(color: Colors.grey))
                      : Text(
                          "Finished on ${formattDate(widget.book.finishedReading)}")),
              RatingBar.builder(
                initialRating:
                    widget.book.rating != null ? widget.book.rating : 3.0,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                  }
                },
                onRatingUpdate: (rating) {
                  print(rating.toInt());
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    maxLines: 2,
                    controller: _notesTextController,
                    decoration:
                        buildInputDecoration("Your thoughts", 'Enter notes'),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TwoSideRoundedButton(
                    text: 'Update',
                    radious: 12,
                    color: kIconColor,
                    press: () {
                      // Only update if new data was entered
                      final userChangedTitle =
                          widget.book.title != _titleTextController.text;
                      final userChangedAuthor =
                          widget.book.author != _authorTextController.text;
                      final userChangedPhotoUrl =
                          widget.book.author != _photoTextController.text;

                      final userChangedNotes =
                          widget.book.notes != _notesTextController.text;

                      final userChangedRating = widget.book.rating != _rating;

                      final bookUpdate = userChangedTitle ||
                          userChangedRating ||
                          userChangedAuthor ||
                          userChangedPhotoUrl ||
                          userChangedNotes;

                      // print('user changed notes $userChangedNotes');

                      if (bookUpdate) {
                        _linkCollection.doc(widget.book.id).update(Book(
                                userId: user.uid,
                                title: _titleTextController.text,
                                author: _authorTextController.text,
                                rating: _rating,
                                photoUrl: _photoTextController.text,
                                startedReading: isReadingClicked
                                    ? Timestamp.now()
                                    : widget.book.startedReading,
                                finishedReading: isFinishedRadingClicked
                                    ? Timestamp.now()
                                    : widget.book.finishedReading,
                                notes: _notesTextController.text)
                            .toMap());
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton.icon(
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
                                      _linkCollection
                                          .doc(widget.book.id)
                                          .delete();
                                      //go back to main page
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MobileMainScreen(),
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
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
            ],
          ),
        ),
      )),
    );

    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Book Details'),
    //     backgroundColor: Colors.brown.shade200,
    //   ),
    //   body: Material(
    //     elevation: 2.0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(35),
    //       child: Form(
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: CircleAvatar(
    //                   backgroundColor: Colors.transparent,
    //                   backgroundImage: NetworkImage('${widget.book.photoUrl}'),
    //                   radius: 50,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   controller: _titleTextController,
    //                   decoration: buildInputDecoration(
    //                       'Book title', 'Gone with the Wind'),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   //obscureText: true, //it's a password :)
    //                   controller: _authorTextController,
    //                   decoration: buildInputDecoration("Author", 'Jeff Doe'),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   controller: _photoTextController,
    //                   decoration: buildInputDecoration("Book cover link", ''),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 3,
    //               ),
    //               Expanded(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     TextButton.icon(
    //                         onPressed: widget.book.startedReading == null
    //                             ? () {
    //                                 //capture the timestamp (date) and update startDate field
    //                                 setState(() {
    //                                   if (isReadingClicked == false) {
    //                                     isReadingClicked = true;
    //                                   } else {
    //                                     isReadingClicked = false;
    //                                   }
    //                                 });
    //                               }
    //                             : null,
    //                         icon: Icon(Icons.book_sharp),
    //                         label: (widget.book.startedReading == null)
    //                             ? (!isReadingClicked)
    //                                 ? Text('Start Reading this Book')
    //                                 : Text(
    //                                     'Started Reading...',
    //                                     style: TextStyle(
    //                                         color: Colors.grey.shade300),
    //                                   )
    //                             : Text(
    //                                 "Started on: ${formattDate(widget.book.startedReading)}")),
    //                     TextButton.icon(
    //                         onPressed: widget.book.finishedReading == null
    //                             ? () {
    //                                 //capture the timestamp (date) and update endDate field
    //                                 setState(() {
    //                                   if (isFinishedRadingClicked == false) {
    //                                     isFinishedRadingClicked = true;
    //                                   } else {
    //                                     isFinishedRadingClicked = false;
    //                                   }
    //                                 });
    //                               }
    //                             : null,
    //                         icon: Icon(Icons.add),
    //                         label: (widget.book.finishedReading == null)
    //                             ? (!isFinishedRadingClicked)
    //                                 ? Text(
    //                                     'Mark as Read',
    //                                   )
    //                                 : Text('Finished Reading!',
    //                                     style: TextStyle(color: Colors.grey))
    //                             : Text(
    //                                 "Finished on ${formattDate(widget.book.finishedReading)}")),
    //                     RatingBar.builder(
    //                       initialRating: widget.book.rating != null
    //                           ? widget.book.rating
    //                           : 3,
    //                       itemCount: 5,
    //                       itemBuilder: (context, index) {
    //                         switch (index) {
    //                           case 0:
    //                             return Icon(
    //                               Icons.sentiment_very_dissatisfied,
    //                               color: Colors.red,
    //                             );
    //                           case 1:
    //                             return Icon(
    //                               Icons.sentiment_dissatisfied,
    //                               color: Colors.redAccent,
    //                             );
    //                           case 2:
    //                             return Icon(
    //                               Icons.sentiment_neutral,
    //                               color: Colors.amber,
    //                             );
    //                           case 3:
    //                             return Icon(
    //                               Icons.sentiment_satisfied,
    //                               color: Colors.lightGreen,
    //                             );
    //                           case 4:
    //                             return Icon(
    //                               Icons.sentiment_very_satisfied,
    //                               color: Colors.green,
    //                             );
    //                         }
    //                       },
    //                       onRatingUpdate: (rating) {
    //                         //print(rating);
    //                         setState(() {
    //                           _rating = rating;
    //                         });
    //                       },
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Padding(
    //                   padding: const EdgeInsets.all(15.0),
    //                   child: TextFormField(
    //                     maxLines: 5,
    //                     controller: _notesTextController,
    //                     decoration: buildInputDecoration(
    //                         "Your thoughts", 'Enter notes'),
    //                   )),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   TextButton(
    //                       style: TextButton.styleFrom(
    //                         primary: Colors.white,
    //                         padding: EdgeInsets.all(15),
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(4)),
    //                         backgroundColor: Colors.amber,
    //                         textStyle: TextStyle(fontSize: 18),
    //                         onSurface: Colors.grey,
    //                       ),
    //                       onPressed: () {
    //                         // Only update if new data was entered
    //                         final userChangedTitle =
    //                             widget.book.title != _titleTextController.text;
    //                         final userChangedAuthor = widget.book.author !=
    //                             _authorTextController.text;
    //                         final userChangedPhotoUrl =
    //                             widget.book.author != _photoTextController.text;

    //                         final userChangedNotes =
    //                             widget.book.notes != _notesTextController.text;

    //                         final userChangedRating =
    //                             widget.book.rating != _rating;

    //                         final bookUpdate = userChangedTitle ||
    //                             userChangedRating ||
    //                             userChangedAuthor ||
    //                             userChangedPhotoUrl ||
    //                             userChangedNotes;

    //                         // print('user changed notes $userChangedNotes');

    //                         if (bookUpdate) {
    //                           _linkCollection.doc(widget.book.id).update(Book(
    //                                   userId: user.uid,
    //                                   // userId: 'TNZUELU1YAV85ok7VpX6VGmTnmm2',
    //                                   title: _titleTextController.text,
    //                                   author: _authorTextController.text,
    //                                   rating: _rating,
    //                                   photoUrl: _photoTextController.text,
    //                                   startedReading: isReadingClicked
    //                                       ? Timestamp.now()
    //                                       : widget.book.startedReading,
    //                                   finishedReading: isFinishedRadingClicked
    //                                       ? Timestamp.now()
    //                                       : widget.book.finishedReading,
    //                                   notes: _notesTextController.text)
    //                               .toMap());
    //                         }

    //                         Navigator.of(context).pop();
    //                       },
    //                       child: Text('Update')),
    //                   TextButton.icon(
    //                       onPressed: () {
    //                         showDialog(
    //                           context: context,
    //                           builder: (context) {
    //                             return AlertDialog(
    //                               title: Text('Are you sure?'),
    //                               content: Text(
    //                                   'Once the book is deleted you can\'t retrieve it back'),
    //                               actions: [
    //                                 TextButton(
    //                                     onPressed: () {
    //                                       // delete!
    //                                       _linkCollection
    //                                           .doc(widget.book.id)
    //                                           .delete();
    //                                       //go back to main page
    //                                       Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 MobileMainScreen(),
    //                                           ));
    //                                     },
    //                                     child: Text('Yes')),
    //                                 TextButton(
    //                                     onPressed: () {
    //                                       Navigator.of(context).pop();
    //                                     },
    //                                     child: Text('No'))
    //                               ],
    //                             );
    //                           },
    //                         );
    //                       },
    //                       icon: Icon(Icons.delete_forever),
    //                       label: Text('Delete')),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
