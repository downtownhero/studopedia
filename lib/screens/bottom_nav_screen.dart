import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/search_screen.dart';
import 'package:studopedia/screens/user_screen.dart';
import 'package:studopedia/widgets/fancy_fab.dart';
import 'home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: kButtonColor,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: _currentIndex == 1
            ? SearchScreen()
            : IndexedStack(
                index: _currentIndex,
                children: [HomeScreen(), SearchScreen(), UserScreen()],
              ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFFdeecf4),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: kSecondaryColor,
            unselectedItemColor: Color(0xFF91A2BA),
            currentIndex: _currentIndex,
            elevation: 0.0,
            items: [Icons.home, Icons.search, Icons.person]
                .asMap()
                .map((key, value) => MapEntry(
                      key,
                      BottomNavigationBarItem(
                        title: Text(''),
                        icon: Icon(
                          value,
                          size: 30.0,
                        ),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
        floatingActionButton: FancyFab(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
