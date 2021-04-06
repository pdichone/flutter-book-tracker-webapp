import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key key,
    @required this.user,
    @required TextEditingController displayNameTextController,
    @required TextEditingController professionTextController,
    @required TextEditingController quoteTextController,
    @required TextEditingController avatarTextController,
  })  : _displayNameTextController = displayNameTextController,
        _professionTextController = professionTextController,
        _quoteTextController = quoteTextController,
        _avatarTextController = avatarTextController,
        super(key: key);

  final MUser user;
  final TextEditingController _displayNameTextController;
  final TextEditingController _professionTextController;
  final TextEditingController _quoteTextController;
  final TextEditingController _avatarTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${user.displayName}'),
      content: Form(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage('${user.avatarUrl}'),
              radius: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _displayNameTextController,
              decoration: buildInputDecoration('', ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _professionTextController,
              decoration: buildInputDecoration("", ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _quoteTextController,
              decoration: buildInputDecoration("", ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _avatarTextController,
              decoration: buildInputDecoration("", ''),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
      actions: [
        TextButton(
            onPressed: () {
              // Only update if new data was entered
              final userChangedName =
                  user.displayName != _displayNameTextController.text;
              final userChangedAvatar =
                  user.avatarUrl != _avatarTextController.text;
              final userChangedProfession =
                  user.profession != _professionTextController.text;

              final userChangedQuote = user.quote != _quoteTextController.text;

              final userUpdate = userChangedName ||
                  userChangedAvatar ||
                  userChangedProfession ||
                  userChangedQuote;

              if (userUpdate) {
                //print('To update ${user.id}');
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id)
                    .update(MUser(
                            uid: user.uid,
                            displayName: _displayNameTextController.text,
                            avatarUrl: _avatarTextController.text,
                            profession: _professionTextController.text,
                            quote: _quoteTextController.text)
                        .toMap());
              }

              Navigator.of(context).pop();
            },
            child: Text('Update')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'))
      ],
    );
  }
}
