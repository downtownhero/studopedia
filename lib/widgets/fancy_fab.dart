import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/screens/upload_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/database.dart';
import 'loading_dialog.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: kButtonColor,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget notesList() {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Container(
      child: FloatingActionButton(
        heroTag: 'new_noteslist',
        onPressed: () {
          String listTitle;
          LoadingDialog().newListDialogBox(
            buttonText: 'Create',
            headText: 'New Noteslist',
            context: context,
            onPressTextField: (value) {
              setState(() {
                listTitle = value;
              });
            },
            onPressCreate: () async {
              String returnString = await Database().createNewList(
                uid: _currentUser.getCurrentUserData.uid,
                listTitle: listTitle.trim(),
                title: null,
                des: null,
                fileUrl: null,
              );
              if (returnString == 'Success') {
                Navigator.pop(context);
                LoadingDialog().infoDialogBox(
                  context: context,
                  loadingText: 'Successful',
                  color: Colors.green,
                  icon: Icons.check,
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ),
                      (route) => false),
                );
              } else {
                Navigator.pop(context);
                LoadingDialog().infoDialogBox(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ),
                      (route) => false),
                  context: context,
                  loadingText: 'Error',
                  contentText: 'Try again later',
                  color: Colors.red,
                  icon: Icons.close,
                );
              }
            },
          );
        },
        tooltip: 'Noteslist',
        child: Icon(
          Icons.create_new_folder,
          color: kSecondaryColor,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget newFile() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'upload_screen',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadScreen(),
            ),
          );
        },
        tooltip: 'New File',
        child: Icon(
          Icons.file_upload,
          color: kSecondaryColor,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: notesList(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: newFile(),
        ),
        toggle(),
      ],
    );
  }
}
