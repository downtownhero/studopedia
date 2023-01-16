import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studopedia/models/color_style.dart';

class LoadingDialog {
  Future<void> dialogBox(
      {BuildContext context, String loadingText = ''}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(loadingText),
            content: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SpinKitChasingDots(
                  color: kSecondaryColor,
                  size: 50.0,
                ),
              ),
            ),
          );
        });
  }

  Future<void> infoDialogBox(
      {BuildContext context,
      String loadingText = '',
      String contentText = '',
      IconData icon,
      @required Function onPressed,
      Color color}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            title: Text(loadingText),
            content: Container(
              height: contentText == '' ? 80 : 100.0,
              child: Column(
                children: <Widget>[
                  contentText == ''
                      ? SizedBox(height: 0.0)
                      : Column(
                          children: <Widget>[
                            Text(
                              contentText,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: onPressed,
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> chooseListDialogBox(
      {BuildContext context, Function onPressEx, Function onPressNew}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text('Choose Noteslist'),
            actions: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: FlatButton(
                  color: kSecondaryColor,
                  onPressed: onPressEx,
                  child: Text(
                    'Add to existing list',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: FlatButton(
                  color: kButtonColor,
                  onPressed: onPressNew,
                  child: Text(
                    'New Noteslist',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> newListDialogBox({
    BuildContext context,
    Function onPressTextField,
    Function onPressCreate,
    String headText,
    String buttonText,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(
              headText,
              style: TextStyle(color: kSecondaryColor),
            ),
            content: Card(
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  hintText: 'Noteslist title',
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                onChanged: onPressTextField,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: kSecondaryColor),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FlatButton(
                  color: kButtonColor,
                  onPressed: onPressCreate,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
