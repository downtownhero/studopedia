import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'bottom_nav_screen.dart';

class UploadingScreen extends StatefulWidget {
  final File selectedFile;
  final String title;
  final String des;

  UploadingScreen({this.selectedFile, this.title, this.des});

  @override
  _UploadingScreenState createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseStorage _firebaseStorage =
      FirebaseStorage(storageBucket: 'gs://studopedia-16.appspot.com');
  StorageUploadTask uploadTask;
  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String fileName =
        'userfile/${_currentUser.getCurrentUserData.uid}/${basename(widget.selectedFile.path)}';
    setState(() {
      uploadTask =
          _firebaseStorage.ref().child(fileName).putFile(widget.selectedFile);
    });

    void storeInDatabase() async {
      String fileUrl =
          await _firebaseStorage.ref().child(fileName).getDownloadURL();
      print(fileUrl);
      Map<String, dynamic> fileData = {
        'title': widget.title,
        'des': widget.des,
        'fileUrl': fileUrl,
      };
      String returnString = await _currentUser.userFile(
          widget.title, widget.des, fileUrl, fileData);
      try {
        if (returnString == 'Success') {
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
          Scaffold.of(_scaffoldKey.currentState.context).showSnackBar(
            SnackBar(
              content: Text('Upload failed. Try again later.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
        stream: uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (uploadTask.isComplete || progressPercent.toInt() == 1)
                Text(
                  'Upload complete!',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
              SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  height: 250.0,
                  width: 250.0,
                  child: CircularProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.black12,
                    strokeWidth: 8.5,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '${(progressPercent * 100).toInt()}% ',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 40.0),
              if (uploadTask.isComplete || progressPercent.toInt() == 1)
                FloatingActionButton.extended(
                  heroTag: 'upload_screen',
                  elevation: 7.0,
                  onPressed: () {
                    LoadingDialog().dialogBox(
                      context: _scaffoldKey.currentState.context,
                      loadingText: 'Loading...',
                    );
                    storeInDatabase();
                  },
                  backgroundColor: kButtonColor,
                  label: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
