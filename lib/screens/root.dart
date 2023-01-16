import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/screens/details_screen.dart';
import 'package:studopedia/screens/login_screen.dart';
import 'package:studopedia/screens/start_screen.dart';
import 'package:studopedia/services/current_user.dart';

enum AuthStatus {
  notLoggedIn,
  loggedIn,
  incompleteInfo,
  start,
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthStatus _authStatus = AuthStatus.start;
// we use this instead of initState because initState cannot be async
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await _currentUser.onStartUp();
    if (returnString == 'Success') {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    } else if (returnString == 'IncompleteInfo') {
      setState(() {
        _authStatus = AuthStatus.incompleteInfo;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue;
    switch (_authStatus) {
      case AuthStatus.start:
        returnValue = StartScreen();
        break;
      case AuthStatus.notLoggedIn:
        returnValue = LoginScreen();
        break;
      case AuthStatus.loggedIn:
        returnValue = BottomNavScreen();
        break;
      case AuthStatus.incompleteInfo:
        returnValue = DetailsScreen();
        break;
    }
    return returnValue;
  }
}
