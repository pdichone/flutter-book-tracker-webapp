import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget? createProfile(BuildContext context, List<MUser> list, User authUser) {
  TextEditingController _displayNameTextController =
      TextEditingController(text: list[0].displayName);
  TextEditingController _professionTextController =
      TextEditingController(text: list[0].profession);
  TextEditingController _avatarTextController =
      TextEditingController(text: list[0].avatarUrl);
  TextEditingController _quoteTextController =
      TextEditingController(text: list[0].quote);

  Widget? widget;

  for (var user in list) {
    widget = Container(
      child: Column(
        children: [
          TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushNamed(context, '/login'));
              },
              icon: Icon(Icons.login_rounded),
              label: Text('SignOut')),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(user.avatarUrl == null
                  ? 'https://media.istockphoto.com/photos/ethnic-profile-picture-id185249635?k=6&m=185249635&s=612x612&w=0&h=8U5SlsY9iGJcHqBSxd_r6PLbgGFylccForDTK8drYcg='
                  : user.avatarUrl!),
              radius: 50,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${user.displayName!.toUpperCase()}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton.icon(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blueGrey.shade100),
                  icon: Icon(Icons.mode_edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfile(
                            user: user,
                            displayNameTextController:
                                _displayNameTextController,
                            professionTextController: _professionTextController,
                            quoteTextController: _quoteTextController,
                            avatarTextController: _avatarTextController);
                      },
                    );
                  },
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Edit'),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${user.profession}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          SizedBox(
            width: 100,
            height: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 100,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.blueGrey.shade100,
                    ),
                    color: HexColor('#f1f3f6'),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text('Favorite Quote:'),
                      SizedBox(
                        width: 100,
                        height: 2,
                        child: Container(
                          color: Colors.greenAccent.shade100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          (user.quote == null)
                              ? 'Favorite Book Quote : Life is great when you\'re not hungry...'
                              : " \"${user.quote} \"",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  return widget;
}
