import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studopedia/components/background.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/notes_list.dart';
import 'package:studopedia/models/save_later.dart';
import 'package:studopedia/screens/noteslist_screen.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/widgets/bottom_sheets.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:provider/provider.dart';

SaveLater userSaveLater;
NotesList notesListTitle;

class HomeScreen extends StatefulWidget {
  SaveLater get currentUserSavedData => userSaveLater;
  SaveLater getSaveLater(SaveLater _saveLater) {
    userSaveLater = _saveLater;
    return userSaveLater;
  }

  NotesList get currentUserListTitle => notesListTitle;
  NotesList getListTitle(NotesList _listTitle) {
    notesListTitle = _listTitle;
    return notesListTitle;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool saveForLater = false;
  bool loading = false;
  bool pdfLoading = false;
  bool emptySaved = false;
  bool emptyList = false;

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: buildHomePage(_currentUser.getCurrentUserData.uid),
    );
  }

  Widget buildHomePage(String uid) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: getSaveLater(uid),
        builder: (context, AsyncSnapshot<SaveLater> asyncSnapshot) {
          return StreamBuilder(
              stream: getNoteslists(uid),
              builder: (context, AsyncSnapshot<NotesList> titleSnapshot) {
                if (asyncSnapshot.data == null && asyncSnapshot.hasError ||
                    titleSnapshot.data == null && titleSnapshot.hasError) {
                  return Text('Error');
                } else if (asyncSnapshot.data == null &&
                    titleSnapshot.data == null) {
                  SaveLater saveLater = asyncSnapshot.data;
                  return Background(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: (20.5 / 100) * size.height),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            'Saved',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          height: (22.65 / 100) * size.height,
                          width: double.infinity,
                          child: Center(
                            child: asyncSnapshot.connectionState ==
                                    ConnectionState.done
                                ? Text(
                                    'No saved files',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : SpinKitChasingDots(
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            'Noteslist',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(height: (7.81 / 100) * size.height),
                        Padding(
                          padding:
                              EdgeInsets.only(top: (7.81 / 100) * size.height),
                          child: Center(
                              child: titleSnapshot.connectionState ==
                                      ConnectionState.done
                                  ? Text(
                                      'Let\'s create a Noteslist!',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : SpinKitChasingDots(
                                      size: 50.0,
                                      color: Colors.white,
                                    )),
                        ),
                      ],
                    ),
                  );
                } else if (asyncSnapshot.data == null &&
                    titleSnapshot.data != null) {
                  SaveLater saveLater = asyncSnapshot.data;
                  widget.getSaveLater(saveLater);
                  NotesList notesList = titleSnapshot.data;
                  widget.getListTitle(notesList);
                  return Background(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: (20.5 / 100) * size.height),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            'Saved',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          height: (22.65 / 100) * size.height,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'No saved files',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Noteslist',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        titleSnapshot.connectionState == ConnectionState.done
                            ? notesList.notesListTitle.length == 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: (7.81 / 100) * size.height),
                                    child: Center(
                                      child: Text(
                                        'Let\'s create a Noteslist!',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : buildNoteslist(size, notesList)
                            : SpinKitChasingDots(
                                color: Colors.white,
                                size: 50.0,
                              ),
                      ],
                    ),
                  );
                } else if (asyncSnapshot.data != null &&
                    titleSnapshot.data == null) {
                  SaveLater saveLater = asyncSnapshot.data;
                  widget.getSaveLater(saveLater);
                  NotesList notesList = titleSnapshot.data;
                  widget.getListTitle(notesList);
                  return Background(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: (20.5 / 100) * size.height),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            'Saved',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          height: (22.0 / 100) * size.height,
                          width: double.infinity,
                          child: Center(
                            child: asyncSnapshot.connectionState ==
                                    ConnectionState.done
                                ? saveLater.userFiles.length == 0 ||
                                        saveLater.userFiles.length == null
                                    ? Text(
                                        'No saved files',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : buildSaveLater(saveLater, uid, size)
                                : SpinKitChasingDots(
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Noteslist',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(height: (7.81 / 100) * size.height),
                        Padding(
                          padding:
                              EdgeInsets.only(top: (7.81 / 100) * size.height),
                          child: Center(
                            child: Text(
                              'Let\'s create a Noteslist!',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (asyncSnapshot.hasData || titleSnapshot.hasData) {
                  SaveLater saveLater = asyncSnapshot.data;
                  widget.getSaveLater(saveLater);
                  NotesList notesList = titleSnapshot.data;
                  widget.getListTitle(notesList);
                  return Background(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: (20.5 / 100) * size.height),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            'Saved',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          height: (22.0 / 100) * size.height,
                          width: double.infinity,
                          child: Center(
                            child: saveLater.userFiles.length == 0
                                ? Text(
                                    'No saved files',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : buildSaveLater(saveLater, uid, size),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Noteslist',
                            style: TextStyle(
                              color: kButtonColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        notesList.notesListTitle.length == 0
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: (7.81 / 100) * size.height),
                                child: Center(
                                  child: Text(
                                    'Let\'s create a Noteslist!',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : buildNoteslist(size, notesList),
                      ],
                    ),
                  );
                }
                return Background(
                    child: SizedBox(
                  height: 20.0,
                ));
              });
        });
  }

  Container buildNoteslist(Size size, NotesList notesList) {
    return Container(
      padding: EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 30.0),
      height: (44.0 / 100) * size.height,
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          int number = notesList.notesListTitle.length - index - 1;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteslistScreen(
                    listTitle: notesList.notesListTitle[number],
                  ),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 10.0),
              padding: EdgeInsets.all(2.0),
              height: (15.625 / 100) * size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kSecondaryColor,
                    Color(0xFF12174a),
                    Theme.of(context).primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 6.0),
                    color: Colors.black45,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Hero(
                transitionOnUserGestures: true,
                tag: 'noteslist${notesList.notesListTitle[number]}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    notesList.notesListTitle[number],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: notesList.notesListTitle.length,
      ),
    );
  }

  ListView buildSaveLater(SaveLater saveLater, String uid, Size size) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: saveLater.userFiles.length,
      itemBuilder: (BuildContext context, int index) {
        int number = saveLater.userFiles.length - index - 1;
        String format;
        Color color = Colors.white;
        List<Color> gradientList = [];
        if (saveLater.userFiles[number].fileUrl.contains('.pdf')) {
          color = Colors.red;
          format = 'pdf';
          gradientList = [
            Colors.red[300],
            Colors.red[400],
            Colors.red[500],
          ];
        } else if (saveLater.userFiles[number].fileUrl.contains('.docx') ||
            saveLater.userFiles[number].fileUrl.contains('.doc')) {
          color = Colors.blue;
          format = 'docx';
          gradientList = [
            Colors.blue[200],
            Colors.blue[300],
            Colors.blue[400],
            Colors.blue[500],
          ];
        } else if (saveLater.userFiles[number].fileUrl.contains('.xlsx') ||
            saveLater.userFiles[number].fileUrl.contains('.xls')) {
          color = Colors.green;
          format = 'xlsx';
          gradientList = [
            Colors.green[200],
            Colors.green[300],
            Colors.green[400],
            Colors.green[500],
          ];
        } else if (saveLater.userFiles[number].fileUrl.contains('.pptx') ||
            saveLater.userFiles[number].fileUrl.contains('.ppt')) {
          color = Colors.deepOrange;
          format = 'pptx';
          gradientList = [
            Colors.deepOrange[300],
            Colors.deepOrange[400],
            Colors.deepOrange[500],
          ];
        }
        return GestureDetector(
          onTap: () async {
            BottomSheets().savedFileBottomSheet(
              context: _scaffoldKey.currentState.context,
              scaffoldKey: _scaffoldKey,
              title: saveLater.userFiles[number].title,
              des: saveLater.userFiles[number].des,
              fileUrl: saveLater.userFiles[number].fileUrl,
              uid: uid,
              format: format,
              color: color,
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
                        context: _scaffoldKey.currentState.context,
                        loadingText: 'Just a moment...');
                    String returnString = await Database().createNewList(
                      uid: uid,
                      listTitle: listTitle.trim(),
                      title: saveLater.userFiles[number].title,
                      des: saveLater.userFiles[number].des,
                      fileUrl: saveLater.userFiles[number].fileUrl,
                    );
                    if (returnString == 'Success') {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      LoadingDialog().infoDialogBox(
                          context: _scaffoldKey.currentState.context,
                          loadingText: 'Successful',
                          color: Colors.green,
                          icon: Icons.check,
                          onPressed: () {
                            Navigator.pop(_scaffoldKey.currentState.context);
                          });
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      LoadingDialog().infoDialogBox(
                        context: _scaffoldKey.currentState.context,
                        loadingText: 'Error',
                        contentText: 'Try again later',
                        color: Colors.red,
                        icon: Icons.close,
                        onPressed: () =>
                            Navigator.pop(_scaffoldKey.currentState.context),
                      );
                    }
                  },
                );
              },
            );
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 4.5, vertical: 7.0),
            width: (35.0 / 100) * size.width,
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientList,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, 5.0),
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              saveLater.userFiles[number].title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
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
    );
  }
}

Stream<SaveLater> getSaveLater(String uid) {
  return Firestore.instance
      .collection('userFile')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return SaveLater.fromSnapshot(querySnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

Stream<NotesList> getNoteslists(String uid) {
  return Firestore.instance
      .collection('userFile')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return NotesList.fromSnapshot(querySnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}
