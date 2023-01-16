import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/file_data.dart';
import 'package:studopedia/models/user_data.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/widgets/bottom_sheets.dart';
import 'package:studopedia/widgets/loading_big.dart';
import 'package:studopedia/widgets/loading_dialog.dart';

class FriendScreen extends StatefulWidget {
  final UserData searchData;
  FriendScreen(this.searchData);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool following = false;
  Future checkFollow(String uid) async {
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.collection('users').document(uid).get();
    List friend = await documentSnapshot.data['following'].map<dynamic>((data) {
      return data['uid'];
    }).toList();
    if (friend == null) {
      following = false;
    } else {
      bool follow = friend.contains(widget.searchData.uid);
      following = follow;
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    await checkFollow(_currentUser.getCurrentUserData.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
        stream: getData(widget.searchData.uid),
        builder: (context, AsyncSnapshot<FileData> asyncSnapshot) {
          if (asyncSnapshot.data == null && asyncSnapshot.hasError) {
            return Text('Error');
          } else if (asyncSnapshot.data == null) {
            FileData fileData = asyncSnapshot.data;
            return backgroundContainer(
              size: size,
              child: Column(
                children: <Widget>[
                  buildAppbar(
                      size, context, _currentUser.getCurrentUserData.uid),
                  buildUserContainer(
                      size, fileData, _currentUser.getCurrentUserData.uid),
                  Container(
                    height: 30.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(
                        10.0, (10.84 / 100) * size.height, 10.0, 0.0),
                    child: Center(
                      child:
                          asyncSnapshot.connectionState == ConnectionState.done
                              ? Text(
                                  'No files found.',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : SpinKitChasingDots(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                    ),
                  ),
                ],
              ),
            );
          } else if (asyncSnapshot.hasData) {
            FileData fileData = asyncSnapshot.data;
            return backgroundContainer(
              size: size,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    buildAppbar(
                        size, context, _currentUser.getCurrentUserData.uid),
                    buildUserContainer(
                        size, fileData, _currentUser.getCurrentUserData.uid),
                    fileData.userFiles == null || fileData.userFiles.length == 0
                        ? Container(
                            height: 30.0,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(
                                10.0, (10.84 / 100) * size.height, 10.0, 0.0),
                            child: Text(
                              'No files found.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 70.0),
                            height: size.height - 280.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GridView.builder(
                              itemCount: fileData.userFiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                int number =
                                    fileData.userFiles.length - index - 1;
                                String format;
                                List<Color> gradientList = [];
                                Color color = Colors.white;
                                if (fileData.userFiles[number].fileUrl
                                    .contains('.pdf')) {
                                  color = Colors.red;
                                  format = 'pdf';
                                  gradientList = [
                                    Colors.red[200],
                                    Colors.red[300],
                                    Colors.red[400],
                                    Colors.red[500],
                                  ];
                                } else if (fileData.userFiles[number].fileUrl
                                        .contains('.docx') ||
                                    fileData.userFiles[number].fileUrl
                                        .contains('.doc')) {
                                  color = Colors.blue;
                                  format = 'docx';
                                  gradientList = [
                                    Colors.blue[200],
                                    Colors.blue[300],
                                    Colors.blue[400],
                                    Colors.blue[500],
                                  ];
                                } else if (fileData.userFiles[number].fileUrl
                                        .contains('.xlsx') ||
                                    fileData.userFiles[number].fileUrl
                                        .contains('.xls')) {
                                  color = Colors.green;
                                  format = 'xlsx';
                                  gradientList = [
                                    Colors.green[200],
                                    Colors.green[300],
                                    Colors.green[400],
                                    Colors.green[500],
                                  ];
                                } else if (fileData.userFiles[number].fileUrl
                                        .contains('.pptx') ||
                                    fileData.userFiles[number].fileUrl
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
                                    BottomSheets().friendBottomSheet(
                                      title: fileData.userFiles[number].title,
                                      des: fileData.userFiles[number].des,
                                      fileUrl:
                                          fileData.userFiles[number].fileUrl,
                                      scaffoldKey: _scaffoldKey,
                                      format: format,
                                      color: color,
                                      uid: _currentUser.getCurrentUserData.uid,
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
                                                await Database().createNewList(
                                              uid: _currentUser
                                                  .getCurrentUserData.uid,
                                              listTitle: listTitle.trim(),
                                              title: fileData
                                                  .userFiles[number].title,
                                              des: fileData
                                                  .userFiles[number].des,
                                              fileUrl: fileData
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
                                                onPressed: () => Navigator.pop(
                                                    _scaffoldKey
                                                        .currentState.context),
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              LoadingDialog().infoDialogBox(
                                                onPressed: () => Navigator.pop(
                                                    _scaffoldKey
                                                        .currentState.context),
                                                context: _scaffoldKey
                                                    .currentState.context,
                                                loadingText: 'Error',
                                                contentText: 'Try again later',
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
                              },
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
          return LoadingBig();
        },
      ),
    );
  }

  Container backgroundContainer({Size size, Widget child}) {
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
      child: SafeArea(
        child: child,
      ),
    );
  }

  Container buildUserContainer(Size size, FileData fileData, String uid) {
    return Container(
      height: 270.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: (3 / 100) * size.height),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: (5.55 / 100) * size.width),
              child: Row(
                children: <Widget>[
                  widget.searchData.imageUrl != null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kButtonColor, width: 1.5),
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
                            backgroundImage:
                                NetworkImage(widget.searchData.imageUrl),
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
                  SizedBox(width: 30.0),
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
                  SizedBox(width: 25.0),
                  if (following)
                    followButton(
                      title: 'Following',
                      color: kButtonColor,
                      onPress: () async {
                        LoadingDialog().dialogBox(
                            context: _scaffoldKey.currentState.context,
                            loadingText: 'Just a moment');
                        var val = [];
                        var map = {
                          'fullName': widget.searchData.fullName,
                          'college': widget.searchData.college,
                          'course': widget.searchData.course,
                          'uid': widget.searchData.uid,
                          'email': widget.searchData.email,
                          'imageUrl': widget.searchData.imageUrl,
                        };
                        val.add(map);
                        String returnString =
                            await Database().unFollow(val, uid);
                        if (returnString == 'Success') {
                          Navigator.pop(context);
                          setState(() {
                            following = false;
                            print(following);
                          });
                        } else {
                          Navigator.pop(context);
                          LoadingDialog().infoDialogBox(
                            context: _scaffoldKey.currentState.context,
                            loadingText: 'Error',
                            onPressed: () => Navigator.pop(context),
                            contentText: 'Try again later',
                            color: Colors.red,
                            icon: Icons.close,
                          );
                        }
                        await Database().followers(uid);
                      },
                    ),
                  if (!following)
                    followButton(
                      title: 'Follow',
                      color: Colors.blue,
                      onPress: () async {
                        LoadingDialog().dialogBox(
                            context: _scaffoldKey.currentState.context,
                            loadingText: 'Just a moment');
                        var val = [];
                        var map = {
                          'fullName': widget.searchData.fullName,
                          'college': widget.searchData.college,
                          'course': widget.searchData.course,
                          'uid': widget.searchData.uid,
                          'email': widget.searchData.email,
                          'imageUrl': widget.searchData.imageUrl,
                        };
                        val.add(map);
                        String returnString = await Database().follow(val, uid);
                        if (returnString == 'Success') {
                          Navigator.pop(context);
                          setState(() {
                            following = true;
                            print(following);
                          });
                        } else {
                          Navigator.pop(context);
                          LoadingDialog().infoDialogBox(
                            context: _scaffoldKey.currentState.context,
                            loadingText: 'Error',
                            onPressed: () => Navigator.pop(context),
                            contentText: 'Try again later',
                            color: Colors.red,
                            icon: Icons.close,
                          );
                        }
                        await Database().followers(uid);
                      },
                    )
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
                    widget.searchData.fullName,
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
                    '${widget.searchData.college} ${widget.searchData.campus}',
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
                    widget.searchData.course,
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
          ],
        ),
      ),
    );
  }

  GestureDetector followButton({String title, Color color, Function onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 100.0,
        height: 40.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 4.0),
                color: Colors.black,
                blurRadius: 4.0,
              ),
            ]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Container buildAppbar(Size size, BuildContext context, String uid) {
    return Container(
      height: (7.03 / 100) * size.height,
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 25.0,
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
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
