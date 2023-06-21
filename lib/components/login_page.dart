import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'package:studopedia/widgets/or_divider.dart';
import 'package:studopedia/widgets/rounded_button.dart';
import 'package:studopedia/widgets/rounded_input_field.dart';
import 'package:studopedia/widgets/rounded_password_field.dart';
import 'SignWithGoogle.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  void loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    LoadingDialog().dialogBox(context: context, loadingText: 'Just a moment');
    String returnString =
        await _currentUser.loginUserWithEmail(email, password);
    try {
      if (returnString == 'Success') {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pop(context);
        setState(() {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect login details!'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void resetPassword(BuildContext context, String email) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    LoadingDialog().dialogBox(context: context, loadingText: 'Just a moment');
    String returnString = await _currentUser.resetPassword(email);
    try {
      if (returnString == 'Success') {
        Navigator.pop(context);
        LoadingDialog().infoDialogBox(
          context: context,
          loadingText: 'Email sent',
          contentText: 'Check your email.',
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
          icon: Icons.check,
        );
      } else {
        Navigator.pop(context);
        LoadingDialog().infoDialogBox(
          context: context,
          loadingText: 'Error',
          contentText: 'Try again later',
          color: Colors.red,
          onPressed: () => Navigator.pop(context),
          icon: Icons.close,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RoundedInputField(
          keyboardType: TextInputType.emailAddress,
          formKey: _emailFormKey,
          hintText: 'Email',
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          icon: Icons.email,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) => {
            setState(() {
              _email = value;
            }),
          },
        ),
        SizedBox(height: 5.0),
        RoundedPasswordField(
          formKey: _passwordFormKey,
          onChanged: (value) => {
            setState(() {
              _password = value;
            }),
          },
        ),
        SizedBox(height: 5.0),
        RoundedButton(
          text: 'LOGIN',
          color: kButtonColor,
          textColor: Colors.white,
          onPress: () => {
            if (_emailFormKey.currentState.validate() &&
                _passwordFormKey.currentState.validate())
              {
                loginUser(_email.trim(), _password.trim(), context),
              }
            else
              {
                setState(() {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Check your Email and Password'),
                    duration: Duration(seconds: 2),
                  ));
                })
              }
          },
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forgot your login details? ',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_emailFormKey.currentState.validate()) {
                  resetPassword(context, _email.trim());
                } else {
                  setState(() {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Enter your email.'),
                      duration: Duration(seconds: 2),
                    ));
                  });
                }
              },
              child: Text(
                'Get help signing in',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        OrDivider(),
        SizedBox(height: 5.0),
        SignWithGoogle(),
      ],
    );
  }
}
