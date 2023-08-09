import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/file_data.dart';
import 'package:studopedia/models/followers_list.dart';
import 'package:studopedia/screens/edit_profile_screen.dart';
import 'package:studopedia/screens/followers_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/widgets/bottom_sheets.dart';
import 'dart:async';
import 'package:studopedia/widgets/loading_big.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'help_screen.dart';
import 'login_screen.dart';

FileData userFileData;

class UserScreen extends StatefulWidget {
  FileData get currentUserData => userFileData;
  FileData getFileData(FileData _fileData) {
    userFileData = _fileData;
    return userFileData;
  }

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool pdfLoading = false;
  List followersList = [];

  void openMail(String subject) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'studopediaapp@gmail.com',
        queryParameters: {
          'subject': subject,
        });
    launch(_emailLaunchUri.toString());
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    followersList =
        await Database().followers(_currentUser.getCurrentUserData.uid);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder(
          stream: getFollowers(_currentUser.getCurrentUserData.uid),
          builder: (context, AsyncSnapshot<FollowersList> snapshot) {
            return StreamBuilder(
                stream: getData(_currentUser.getCurrentUserData.uid),
                builder: (context, AsyncSnapshot<FileData> asyncSnapshot) {
                  bool loadFile = false;
                  if (asyncSnapshot.connectionState == ConnectionState.done) {
                    loadFile = true;
                  }
                  if ((asyncSnapshot.data == null && asyncSnapshot.hasError) ||
                      (snapshot.data == null && snapshot.hasError)) {
                    return Text('Error');
                  } else if (asyncSnapshot.hasData) {
                    FileData fileData = asyncSnapshot.data;
                    FollowersList followersList = snapshot.data;
                    widget.getFileData(fileData);
                    return loading
                        ? LoadingBig()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: CustomScrollView(
                              slivers: <Widget>[
                                buildSliverAppBar(context, _currentUser,
                                    fileData, followersList, loadFile),
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return buildGridContainer(
                                        fileData,
                                        index,
                                        pdfLoading,
                                        _currentUser.getCurrentUserData.uid,
                                      );
                                    },
                                    childCount: fileData.userFiles.length,
                                  ),
                                ),
                              ],
                            ),
                          );
                  } else if (asyncSnapshot.data == null) {
                    FileData fileData = asyncSnapshot.data;
                    FollowersList followersList = snapshot.data;
                    return Container(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          buildSliverAppBar(context, _currentUser, fileData,
                              followersList, loadFile),
                        ],
                      ),
                    );
                  }
                  return LoadingBig();
                });
          }),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: kButtonColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              accountName: Text(
                _currentUser.getCurrentUserData.fullName == null
                    ? 'Update name in edit profile'
                    : _currentUser.getCurrentUserData.fullName,
              ),
              accountEmail: Text(_currentUser.getCurrentUserData.email),
              currentAccountPicture: _currentUser.getCurrentUserData.imageUrl !=
                      null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kSecondaryColor, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 4.0,
                            offset: Offset(0.0, 2.5),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 52.0,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            _currentUser.getCurrentUserData.imageUrl),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 55.0,
                        color: Colors.grey,
                      ),
                    ),
            ),
            SizedBox(height: 5.0),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
              child: menuContainer('Edit Profile', Icons.edit),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpScreen(),
                    ),
                  );
                },
                child: menuContainer('Help & feedback', Icons.help_outline)),
            GestureDetector(
              onTap: () {
                openMail('Report an issue');
              },
              child: menuContainer('Issue', Icons.bug_report),
            ),
            GestureDetector(
              onTap: () async {
                String returnString = await _currentUser.signOut();
                if (returnString == 'Success') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                }
              },
              child: menuContainer('Logout', Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }

  Container menuContainer(String text, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }

  GestureDetector buildGridContainer(
      FileData fileData, int index, bool pdfLoading, String uid) {
    int number = fileData.userFiles.length - index - 1;
    String format;
    List<Color> gradientList = [];
    Color color = Colors.white;
    if (fileData.userFiles[number].fileUrl.contains('.pdf')) {
      color = Color(0xFFE24747);
      gradientList = [
        Colors.red[200],
        Colors.red[300],
        Colors.red[400],
        Colors.red[500],
      ];
      format = 'pdf';
    } else if (fileData.userFiles[number].fileUrl.contains('.docx') ||
        fileData.userFiles[number].fileUrl.contains('.doc')) {
      color = Colors.blue;
      gradientList = [
        Colors.blue[200],
        Colors.blue[300],
        Colors.blue[400],
        Colors.blue[500],
      ];
      format = 'docx';
    } else if (fileData.userFiles[number].fileUrl.contains('.xlsx') ||
        fileData.userFiles[number].fileUrl.contains('.xls')) {
      color = Colors.green;
      gradientList = [
        Colors.green[200],
        Colors.green[300],
        Colors.green[400],
        Colors.green[500],
      ];
      format = 'xlsx';
    } else if (fileData.userFiles[number].fileUrl.contains('.pptx') ||
        fileData.userFiles[number].fileUrl.contains('.ppt')) {
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
      onTap: () {
        BottomSheets().modalBottomSheet(
          uid: uid,
          title: fileData.userFiles[number].title,
          des: fileData.userFiles[number].des,
          fileUrl: fileData.userFiles[number].fileUrl,
          format: format,
          color: color,
          context: _scaffoldKey.currentState.context,
          scaffoldKey: _scaffoldKey,
          onPressNew: () {
            Navigator.pop(context);
            String listTitle;
            LoadingDialog().newListDialogBox(
              buttonText: 'Create',
              headText: 'New Noteslist',
              context: _scaffoldKey.currentState.context,
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
                  title: fileData.userFiles[number].title,
                  des: fileData.userFiles[number].des,
                  fileUrl: fileData.userFiles[number].fileUrl,
                );
                if (returnString == 'Success') {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  LoadingDialog().infoDialogBox(
                    context: _scaffoldKey.currentState.context,
                    loadingText: 'Successful',
                    color: Colors.green,
                    onPressed: () =>
                        Navigator.pop(_scaffoldKey.currentState.context),
                    icon: Icons.check,
                  );
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  LoadingDialog().infoDialogBox(
                    context: _scaffoldKey.currentState.context,
                    loadingText: 'Error',
                    contentText: 'Try again later',
                    color: Colors.red,
                    onPressed: () =>
                        Navigator.pop(_scaffoldKey.currentState.context),
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
        padding: EdgeInsets.symmetric(horizontal: 3.0),
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
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          fileData.userFiles[number].title,
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
  }

  SliverAppBar buildSliverAppBar(BuildContext context, CurrentUser _currentUser,
      FileData fileData, FollowersList followersList, bool loadFile) {
    Size size = MediaQuery.of(context).size;
    return SliverAppBar(
      elevation: 0.0,
      expandedHeight: fileData == null || fileData.userFiles.length == 0
          ? size.height
          : 305.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: (7.97 / 100) * size.height),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: (5.55 / 100) * size.width),
                child: Row(
                  children: <Widget>[
                    _currentUser.getCurrentUserData.imageUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kButtonColor, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 4.0),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 52.0,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  _currentUser.getCurrentUserData.imageUrl),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kSecondaryColor,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 100.0,
                              color: Colors.grey,
                            ),
                          ),
                    SizedBox(width: (9.72 / 100) * size.width),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            fileData == null
                                ? '0'
                                : '${fileData.userFiles.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Notes',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: (6.94 / 100) * size.width),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowersScreen())),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              followersList == null ||
                                      followersList.followers.length == 0
                                  ? '0'
                                  : '${followersList.followers.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: (6.388 / 100) * size.width, top: 18.0, right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _currentUser.getCurrentUserData.fullName == null
                          ? 'Update name in edit profile'
                          : _currentUser.getCurrentUserData.fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.6),
                    Text(
                      _currentUser.getCurrentUserData.college == null ||
                              _currentUser.getCurrentUserData.campus == null
                          ? 'Update college & campus in edit profile'
                          : '${_currentUser.getCurrentUserData.college} ${_currentUser.getCurrentUserData.campus}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.6),
                    Text(
                      _currentUser.getCurrentUserData.course == null
                          ? 'Update course in edit profile'
                          : _currentUser.getCurrentUserData.course,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'All Uploads',
                  style: TextStyle(
                    color: kButtonColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              fileData == null || fileData.userFiles.length == 0
                  ? !loadFile
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: (8.0 / 100) * size.height),
                          child: SpinKitChasingDots(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        )
                      : Container(
                          margin:
                              EdgeInsets.only(top: (8.0 / 100) * size.height),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.library_books,
                                size: 30.0,
                                color: Colors.white60,
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Add some notes',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                  : SizedBox(height: 0.5)
            ],
          ),
        ),
      ),
    );
  }
}

Stream<FileData> getData(String uid) {
  return Firestore.instance
      .collection('userFile')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return FileData.fromSnapshot(querySnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

Stream<FollowersList> getFollowers(String uid) {
  return Firestore.instance
      .collection('users')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return FollowersList.fromSnapshot(querySnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}
