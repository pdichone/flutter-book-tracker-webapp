import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  const CreateAccountForm({
    Key key,
    @required TextEditingController emailTextController,
    @required TextEditingController passwordTextController,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Please enter a valid email and a password that is at least 6 characters.'),
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
              onPressed: () {},
              child: Text('Create Account')),
        ],
      ),
    );
  }
}
