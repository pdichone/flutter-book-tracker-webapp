import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailTextController,
              decoration: buildInputDecoration('Email', 'gina@google.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              obscureText: true, //it's a password :)
              controller: _passwordTextController,
              decoration: buildInputDecoration("Password", ''),
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
              onPressed: () {},
              child: Text('Sign In')),
        ],
      ),
    );
  }
}
