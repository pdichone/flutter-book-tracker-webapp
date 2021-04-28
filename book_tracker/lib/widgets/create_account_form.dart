import 'dart:io';

import 'package:book_tracker/mobile/screens/mobile_main_screen.dart';
import 'package:book_tracker/services/create_user.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState> _globalKey;

  const CreateAccountForm({
    Key key,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
    @required Key formKey,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    //var isMobile = Platform.isIOS || Platform.isAndroid;
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Please enter a valid email and a password that is at least 6 characters.'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value.isEmpty ? 'Please add an email' : null;
              },
              controller: _emailTextController,
              decoration: buildInputDecoration('Email', 'gina@google.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value.isEmpty
                    ? 'Password must be at least 6 chars long'
                    : null;
              },
              obscureText: true, //it's a password :)
              controller: _passwordTextController,
              decoration: buildInputDecoration('password', ''),
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
                textStyle: TextStyle(
                  fontSize: 18,
                ),
                onSurface: Colors.grey,
              ),
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  String email = _emailTextController.text;
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: _passwordTextController.text)
                      .then((value) {
                    if (value.user != null) {
                      // go ahead and create a user and sign them in!
                      createUser(email.toString().split('@')[0], context)
                          .then((value) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email,
                                password: _passwordTextController.text)
                            .then((value) {
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileMainScreen()),
                          );
                          // !kIsWeb
                          //     ? Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => MobileMainScreen()),
                          //       )
                          //     : Navigator.of(context).pushNamed('/main');
                          // return Navigator.of(context).pushNamed('/main');
                        });
                      });
                    }

                    //print('${value.user.displayName}');
                  });
                }
              },
              child: Text('Create Account')),
        ],
      ),
    );
  }
}
