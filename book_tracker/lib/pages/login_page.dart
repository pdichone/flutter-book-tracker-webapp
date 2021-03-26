import 'package:book_tracker/pages/create_account_page.dart';
import 'package:book_tracker/widgets/create_account_form.dart';
import 'package:book_tracker/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();
  bool isCreateAccountClicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: HexColor('#B9C2D1'),
                )),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: isCreateAccountClicked != true
                      ? LoginForm(
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)
                      : CreateAccountForm(
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController,
                        ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.portrait_rounded),
                  label: Text(isCreateAccountClicked
                      ? 'Already have an account?'
                      : 'Create Account'),
                  style: TextButton.styleFrom(
                    primary: HexColor('#FD5B28'),
                    textStyle:
                        TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    onSurface: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isCreateAccountClicked) {
                        isCreateAccountClicked = true;
                      } else
                        isCreateAccountClicked = false;
                    });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => CreateAccountPage(),
                    //     ));
                  },
                ),
              ],
            ),
            Expanded(
                flex: 2,
                child: Container(
                  color: HexColor('#B9C2D1'),
                )),
          ],
        ),
      ),
    );
  }
}
