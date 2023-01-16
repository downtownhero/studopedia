import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/details_screen.dart';
import 'package:studopedia/screens/terms_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'package:studopedia/widgets/or_divider.dart';
import 'package:studopedia/widgets/rounded_button.dart';
import 'package:studopedia/widgets/rounded_input_field.dart';
import 'package:studopedia/widgets/rounded_password_field.dart';
import 'SignWithGoogle.dart';

class SignupTab extends StatefulWidget {
  @override
  _SignupTabState createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  String _email;
  String _password;
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  void signUpUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    LoadingDialog().dialogBox(context: context, loadingText: 'Just a moment');
    String returnString = await _currentUser.signUpUser(email, password);
    try {
      if (returnString == 'Success') {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pop(context);
        setState(() {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(returnString),
              duration: Duration(seconds: 2),
            ),
          );
        });
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
          formKey: _emailFormKey,
          hintText: 'Email Address',
          textCapitalization: TextCapitalization.none,
          icon: Icons.email,
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          keyboardType: TextInputType.emailAddress,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'By pressing "sign up" you agree to our',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 1.0),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsScreen(),
                ),
              ),
              child: Text(
                'Terms & Conditions',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.0),
        RoundedButton(
          text: 'SIGN UP',
          color: kButtonColor,
          textColor: Colors.white,
          onPress: () {
            if (_emailFormKey.currentState.validate() &&
                _passwordFormKey.currentState.validate()) {
              signUpUser(_email.trim(), _password.trim(), context);
            } else {
              setState(() {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Check your Email and Password'),
                  duration: Duration(seconds: 2),
                ));
              });
            }
          },
        ),
        SizedBox(height: 2.5),
        OrDivider(),
        SizedBox(height: 3.0),
        SignWithGoogle(),
      ],
    );
  }
}
