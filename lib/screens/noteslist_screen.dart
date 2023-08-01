import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/noteslist_data.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/widgets/bottom_sheets.dart';
import 'package:studopedia/widgets/loading_big.dart';
import 'package:studopedia/widgets/loading_dialog.dart';

class NoteslistScreen extends StatefulWidget {
  final String listTitle;
  NoteslistScreen({this.listTitle});
  @override
  _NoteslistScreenState createState() => _NoteslistScreenState();
}

class _NoteslistScreenState extends State<NoteslistScreen> {
  bool pdfLoading = false;
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
          stream: getNoteslistData(
              _currentUser.getCurrentUserData.uid, widget.listTitle),
          builder: (BuildContext context,
              AsyncSnapshot<NoteslistData> asyncSnapshot) {
            if (asyncSnapshot.data == null && asyncSnapshot.hasError) {
              return Text('Error');
            } else if (asyncSnapshot.data == null) {
              NoteslistData noteslistData = asyncSnapshot.data;
              return buildBackground(
                size,
                context,
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      buildAppbar(
                          size, context, _currentUser.getCurrentUserData.uid),
                      Container(
                        height: size.height - ((13.5 / 100) * size.height),
                        child: Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (asyncSnapshot.hasData) {
              NoteslistData noteslistData = asyncSnapshot.data;
              return buildBackground(
                size,
                context,
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      buildAppbar(
                          size, context, _currentUser.getCurrentUserData.uid),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        height: size.height - ((13.5 / 100) * size.height),
                        child: noteslistData.userFiles.length == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.library_books,
                                    size: 40.0,
                                    color: Colors.white60,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Add some notes',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : GridView.builder(
                                itemCount: noteslistData.userFiles.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  int number = noteslistData.userFiles.length -
                                      index -
                                      1;
                                  String format;
                                  Color color = Colors.white;
                                  List<Color> gradientList = [];
                                  if (noteslistData.userFiles[number].fileUrl
                                      .contains('.pdf')) {
                                    color = Colors.red;
                                    gradientList = [
                                      Colors.red[200],
                                      Colors.red[300],
                                      Colors.red[400],
                                      Colors.red[500],
                                    ];
                                    format = 'pdf';
                                  } else if (noteslistData
                                          .userFiles[number].fileUrl
                                          .contains('.docx') ||
                                      noteslistData.userFiles[number].fileUrl
                                          .contains('.doc')) {
                                    color = Colors.blue;
                                    format = 'docx';
                                    gradientList = [
                                      Colors.blue[200],
                                      Colors.blue[300],
                                      Colors.blue[400],
                                      Colors.blue[500],
                                    ];
                                  } else if (noteslistData
                                          .userFiles[number].fileUrl
                                          .contains('.xlsx') ||
                                      noteslistData.userFiles[number].fileUrl
                                          .contains('.xls')) {
                                    color = Colors.green;
                                    format = 'xlsx';
                                    gradientList = [
                                      Colors.green[200],
                                      Colors.green[300],
                                      Colors.green[400],
                                      Colors.green[500],
                                    ];
                                  } else if (noteslistData
                                          .userFiles[number].fileUrl
                                          .contains('.pptx') ||
                                      noteslistData.userFiles[number].fileUrl
                                          .contains('.ppt')) {
                                    color = Colors.deepOrange;
                                    format = 'pptx';
                                    gradientList = [
                                      Colors.deepOrange[200],
                                      Colors.deepOrange[300],
                                      Colors.deepOrange[400],
                                      Colors.deepOrange[500],
                                    ];
                                  }
                                  return GestureDetector(
                                    onTap: () async {
                                      BottomSheets().noteslistBottomSheet(
                                        title: noteslistData
                                            .userFiles[number].title,
                                        des:
                                            noteslistData.userFiles[number].des,
                                        fileUrl: noteslistData
                                            .userFiles[number].fileUrl,
                                        scaffoldKey: _scaffoldKey,
                                        format: format,
                                        color: color,
                                        listTitle: widget.listTitle,
                                        uid:
                                            _currentUser.getCurrentUserData.uid,
                                        context:
                                            _scaffoldKey.currentState.context,
                                        onPressNew: () {
                                          String listTitle;
                                          Navigator.pop(context);
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
                                              LoadingDialog().dialogBox(
                                                  context: _scaffoldKey
                                                      .currentState.context,
                                                  loadingText:
                                                      'Just a moment...');
                                              String returnString =
                                                  await Database()
                                                      .createNewList(
                                                uid: _currentUser
                                                    .getCurrentUserData.uid,
                                                listTitle: listTitle.trim(),
                                                title: noteslistData
                                                    .userFiles[number].title,
                                                des: noteslistData
                                                    .userFiles[number].des,
                                                fileUrl: noteslistData
                                                    .userFiles[number].fileUrl,
                                              );
                                              if (returnString == 'Success') {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                LoadingDialog().infoDialogBox(
                                                  context: _scaffoldKey
                                                      .currentState.context,
                                                  loadingText: 'Successful',
                                                  color: Colors.green,
                                                  icon: Icons.check,
                                                  onPressed: () =>
                                                      Navigator.pop(_scaffoldKey
                                                          .currentState
                                                          .context),
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                LoadingDialog().infoDialogBox(
                                                  onPressed: () =>
                                                      Navigator.pop(_scaffoldKey
                                                          .currentState
                                                          .context),
                                                  context: _scaffoldKey
                                                      .currentState.context,
                                                  loadingText: 'Error',
                                                  contentText:
                                                      'Try again later',
                                                  color: Colors.red,
                                                  icon: Icons.close,
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 4.5,
                                        horizontal: 4.0,
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradientList,
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(0.0, 6.0),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Text(
                                        noteslistData.userFiles[number].title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return LoadingBig();
          }),
    );
  }

  Container buildBackground(Size size, BuildContext context, Widget child) {
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF12174a),
            Color(0xFF0d1036),
            Color(0xFF080a21),
          ],
          stops: [0.15, 0.5, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }

  Container buildAppbar(Size size, BuildContext context, String uid) {
    return Container(
      height: (13.5 / 100) * size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 4.0),
            color: Colors.black,
          )
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFFdeecf4),
            Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Hero(
              tag: 'noteslist${widget.listTitle}',
              child: Material(
                type: MaterialType.transparency,
                child: Icon(Icons.arrow_back),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: kSecondaryColor,
            iconSize: 24.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            width: size.width * 0.6,
            child: Center(
              child: Text(
                widget.listTitle,
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          PopupMenuButton(
              onSelected: (value) async {
                String newTitle;
                if (value == 0) {
                  LoadingDialog().newListDialogBox(
                      context: context,
                      headText: 'Edit title',
                      buttonText: 'Update',
                      onPressTextField: (value) {
                        setState(() {
                          newTitle = value;
                        });
                      },
                      onPressCreate: () async {
                        Navigator.pop(context);
                        LoadingDialog().dialogBox(
                          context: context,
                          loadingText: 'Updating...',
                        );
                        String returnString = await Database().updateListTitle(
                          newTitle,
                          uid,
                          widget.listTitle,
                        );
                        if (returnString == 'Success') {
                          Navigator.pop(context);
                          LoadingDialog().infoDialogBox(
                              context: _scaffoldKey.currentState.context,
                              loadingText: 'Successful',
                              color: Colors.green,
                              icon: Icons.check,
                              onPressed: () => Navigator.pushAndRemoveUntil(
                                  _scaffoldKey.currentState.context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavScreen(),
                                  ),
                                  (route) => false));
                        } else {
                          Navigator.pop(context);
                          LoadingDialog().infoDialogBox(
                            context: _scaffoldKey.currentState.context,
                            loadingText: 'Error',
                            contentText: 'Try again later',
                            color: Colors.red,
                            icon: Icons.close,
                            onPressed: () => Navigator.pop(
                                _scaffoldKey.currentState.context),
                          );
                        }
                      });
                }
                if (value == 1) {
                  LoadingDialog().dialogBox(
                    context: _scaffoldKey.currentState.context,
                    loadingText: 'Deleting...',
                  );
                  Database().deleteList(uid, widget.listTitle).whenComplete(() {
                    Navigator.pop(_scaffoldKey.currentState.context);
                    Navigator.pushAndRemoveUntil(
                        _scaffoldKey.currentState.context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavScreen(),
                        ),
                        (route) => false);
                  });
                }
              },
              captureInheritedThemes: false,
              icon: Icon(
                Icons.more_vert,
                color: kSecondaryColor,
                size: 22.0,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: kSecondaryColor,
                      ),
                      title: Text(
                        'Noteslist title',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: kSecondaryColor,
                      ),
                      title: Text(
                        'Delete noteslist',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ];
              }),
        ],
      ),
    );
  }
}

Stream<NoteslistData> getNoteslistData(String uid, String listTitle) {
  return Firestore.instance
      .collection('userNoteslist')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return NoteslistData.fromSnapshot(querySnapshot, listTitle);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}
