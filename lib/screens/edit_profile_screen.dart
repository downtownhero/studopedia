import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/services/uploader.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'bottom_nav_screen.dart';
import 'package:studopedia/widgets/loading_big.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _imageUrl;
  bool loading = false;
  Uploader _uploader = Uploader();

  File _image;
  final picker = ImagePicker();
  getImageFile(ImageSource source) async {
    var image = await picker.getImage(source: source, imageQuality: 70);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    setState(() {
      _image = croppedFile;
    });
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String imageUrl = await _uploader.uploadPic(
        _image, _currentUser.getCurrentUserData.uid, _image.path);

    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return loading
        ? LoadingBig()
        : WillPopScope(
            onWillPop: () async {
              String returnString = await _currentUser.onStartUp();
              if (returnString == 'Success') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavScreen(),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavScreen(),
                  ),
                  (route) => false,
                );
              }
              return false;
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Theme.of(context).primaryColor,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        top: 10.0,
                      ),
                      height: (15 / 100) * size.height,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10.0,
                            left: -15.0,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () async {
                                String returnString =
                                    await _currentUser.onStartUp();
                                if (returnString == 'Success') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      width: double.infinity,
                      height: size.height - ((15 / 100) * size.height),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 66.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kSecondaryColor,
                                    ),
                                    child: _image != null
                                        ? ClipOval(
                                            child: Image.file(
                                              _image,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 90.0,
                                            color: Colors.white70,
                                          ),
                                  ),
                                  IconButton(
                                    padding:
                                        EdgeInsets.only(top: 65.0, right: 60.0),
                                    icon: Icon(Icons.photo_camera),
                                    iconSize: 27.0,
                                    onPressed: () =>
                                        getImageFile(ImageSource.gallery),
                                    color: kSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FloatingActionButton.extended(
                                  heroTag: 'remove',
                                  onPressed: () async {
                                    setState(() {
                                      _image = null;
                                    });
                                    String returnString = await Database()
                                        .updateImageUrl(
                                            null,
                                            _currentUser
                                                .getCurrentUserData.uid);
                                    if (returnString == 'Success') {
                                      LoadingDialog().infoDialogBox(
                                        context:
                                            scaffoldKey.currentState.context,
                                        loadingText: 'Update Successful',
                                        color: Colors.green,
                                        icon: Icons.check,
                                        onPressed: () => Navigator.pop(
                                            scaffoldKey.currentState.context),
                                      );
                                    } else {
                                      LoadingDialog().infoDialogBox(
                                        onPressed: () => Navigator.pop(
                                            scaffoldKey.currentState.context),
                                        context:
                                            scaffoldKey.currentState.context,
                                        loadingText: 'Error',
                                        contentText: 'Try again later',
                                        color: Colors.red,
                                        icon: Icons.close,
                                      );
                                    }
                                  },
                                  backgroundColor: Colors.white70,
                                  label: Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                FloatingActionButton.extended(
                                  elevation: 7.0,
                                  onPressed: () async {
                                    String returnString = await Database()
                                        .updateImageUrl(
                                            _imageUrl,
                                            _currentUser
                                                .getCurrentUserData.uid);
                                    if (returnString == 'Success') {
                                      LoadingDialog().infoDialogBox(
                                        context:
                                            scaffoldKey.currentState.context,
                                        loadingText: 'Update Successful',
                                        color: Colors.green,
                                        icon: Icons.check,
                                        onPressed: () => Navigator.pop(
                                            scaffoldKey.currentState.context),
                                      );
                                    } else {
                                      LoadingDialog().infoDialogBox(
                                        context:
                                            scaffoldKey.currentState.context,
                                        loadingText: 'Error',
                                        contentText: 'Try again later',
                                        color: Colors.red,
                                        icon: Icons.close,
                                        onPressed: () => Navigator.pop(
                                            scaffoldKey.currentState.context),
                                      );
                                    }
                                  },
                                  backgroundColor: kButtonColor,
                                  label: Text(
                                    'Update image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.0),
                            buildUpdateButton(
                              text: 'Update name',
                              icon: Icons.person,
                              hintText: 'Full name',
                              uid: _currentUser.getCurrentUserData.uid,
                              functionCall: 'updateName',
                              oldName: _currentUser.getCurrentUserData.fullName,
                            ),
                            SizedBox(height: 20.0),
                            buildUpdateButton(
                              text: 'Update college',
                              icon: Icons.school,
                              hintText: 'College name',
                              uid: _currentUser.getCurrentUserData.uid,
                              functionCall: 'updateCollege',
                              oldCollege:
                                  _currentUser.getCurrentUserData.college,
                            ),
                            SizedBox(height: 20.0),
                            buildUpdateButton(
                              text: 'Update campus',
                              icon: Icons.location_city,
                              hintText: 'Campus location',
                              uid: _currentUser.getCurrentUserData.uid,
                              functionCall: 'updateCampus',
                            ),
                            SizedBox(height: 20.0),
                            buildUpdateButton(
                              text: 'Update course',
                              icon: Icons.book,
                              hintText: 'Course / Branch / Field',
                              uid: _currentUser.getCurrentUserData.uid,
                              functionCall: 'updateCourse',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  GestureDetector buildUpdateButton({
    String text = '',
    IconData icon,
    String hintText,
    String uid,
    String functionCall,
    String oldName = '',
    String oldCollege = '',
  }) {
    String functionText;

    return GestureDetector(
      onTap: () {
        showDialog(
            context: scaffoldKey.currentState.context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(text),
                content: Card(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      hintText: hintText,
                    ),
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        functionText = value;
                      });
                    },
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
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(scaffoldKey.currentState.context);
                      LoadingDialog().dialogBox(
                          context: scaffoldKey.currentState.context,
                          loadingText: 'Updating...');
                      String returnString;
                      if (functionCall == 'updateName') {
                        returnString = await Database()
                            .updateName(functionText.trim(), uid, oldName);
                      } else if (functionCall == 'updateCollege') {
                        returnString = await Database().updateCollege(
                            functionText.trim(), uid, oldCollege);
                      } else if (functionCall == 'updateCampus') {
                        returnString = await Database()
                            .updateCampus(functionText.trim(), uid);
                      } else if (functionCall == 'updateCourse') {
                        returnString = await Database()
                            .updateCourse(functionText.trim(), uid);
                      }
                      if (returnString == 'Success') {
                        Navigator.pop(scaffoldKey.currentState.context);
                        LoadingDialog().infoDialogBox(
                          onPressed: () =>
                              Navigator.pop(scaffoldKey.currentState.context),
                          context: scaffoldKey.currentState.context,
                          loadingText: 'Update Successful',
                          color: Colors.green,
                          icon: Icons.check,
                        );
                      } else {
                        Navigator.pop(scaffoldKey.currentState.context);
                        LoadingDialog().infoDialogBox(
                          context: scaffoldKey.currentState.context,
                          onPressed: () =>
                              Navigator.pop(scaffoldKey.currentState.context),
                          loadingText: 'Error',
                          contentText: 'Try again later',
                          color: Colors.red,
                          icon: Icons.close,
                        );
                      }
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: kButtonColor),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (23.0 / 100) * MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 50.0,
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 4.5),
              color: Colors.black38,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 18.5),
            ),
          ],
        ),
      ),
    );
  }
}
