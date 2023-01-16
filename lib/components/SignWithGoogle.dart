import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/screens/details_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/widgets/loading_dialog.dart';

class SignWithGoogle extends StatefulWidget {
  const SignWithGoogle({
    Key key,
  }) : super(key: key);

  @override
  _SignWithGoogleState createState() => _SignWithGoogleState();
}

class _SignWithGoogleState extends State<SignWithGoogle> {
  void loginWithGoogle(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
//    setState(() {
//      loading = true;
//    });
    LoadingDialog().dialogBox(context: context, loadingText: 'Just a moment');
    String returnString = await _currentUser.loginUserWithGoogle();

    try {
      if (returnString == 'newUser') {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen()),
          (Route<dynamic> route) => false,
        );
      } else if (returnString == 'oldUser') {
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
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0.0, 2.0),
            ),
          ]),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: size.width * 0.8,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        onPressed: () => loginWithGoogle(context),
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/gicon.png'),
              height: 40.0,
              width: 40.0,
            ),
            SizedBox(width: 30.0),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 18.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
