import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/services/uploader.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'package:studopedia/widgets/rounded_button.dart';
import 'package:studopedia/widgets/rounded_input_field.dart';
import 'bottom_nav_screen.dart';
import 'package:studopedia/widgets/loading_big.dart';
import 'package:image_picker/image_picker.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _name;
  String _college;
  String _location;
  String _course;
  String _imageUrl;
  final _nameFormKey = GlobalKey<FormState>();
  final _collegeFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _courseFormKey = GlobalKey<FormState>();
  bool loading = false;
  Uploader _uploader = Uploader();

  void updateDetails(
      String name, String college, String location, String course) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    setState(() {
      loading = true;
    });
    List<String> searchList = [];
    List<String> nameSplit = name.split(' ');
    String newNameText = nameSplit[0];
    for (int i = 1; i < nameSplit.length; i++) {
      newNameText = '$newNameText ${nameSplit[i]}';
      searchList.add(newNameText);
    }
    for (int i = 0; i < nameSplit.length; i++) {
      for (int j = 0; j < nameSplit[i].length + 1; j++) {
        searchList.add(nameSplit[i].substring(0, j));
      }
    }
    List<String> collegeSplit = college.split(' ');
    String newCollegeText = collegeSplit[0];
    for (int i = 1; i < collegeSplit.length; i++) {
      newCollegeText = '$newCollegeText ${collegeSplit[i]}';
      searchList.add(newCollegeText);
    }
    for (int i = 0; i < collegeSplit.length; i++) {
      for (int j = 0; j < collegeSplit[i].length + 1; j++) {
        searchList.add(collegeSplit[i].substring(0, j));
      }
    }

    String returnString = await _currentUser.userDetails(
        name, college, location, course, _imageUrl, searchList);
    try {
      if (returnString == 'Success') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(returnString),
              duration: Duration(seconds: 2),
            ),
          );
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  File _image;
  final picker = ImagePicker();
  getImageFile(ImageSource source) async {
    var image = await picker.getImage(source: source, imageQuality: 70);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.square,
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
    LoadingDialog().dialogBox(
      context: context,
      loadingText: 'Uploading...',
    );
    String imageUrl = await _uploader.uploadPic(
        _image, _currentUser.getCurrentUserData.uid, _image.path);
    Navigator.pop(context);
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? LoadingBig()
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      top: 10.0,
                    ),
                    height: (20.35 / 100) * size.height,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Enter your details to continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15.0),
                    width: double.infinity,
                    height: size.height - ((20.35 / 100) * size.height),
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
                            margin: EdgeInsets.only(
                                left: (18.33 / 100) * size.width),
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
                          SizedBox(height: 20.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: RoundedInputField(
                              formKey: _nameFormKey,
                              textCapitalization: TextCapitalization.words,
                              hintText: 'Full Name',
                              icon: Icons.person,
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    _name = value;
                                  });
                                });
                              },
                              validator: (value) =>
                                  value.isEmpty ? 'Name can\'t be empty' : null,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: RoundedInputField(
                              formKey: _collegeFormKey,
                              onChanged: (value) {
                                setState(() {
                                  _college = value;
                                });
                              },
                              hintText: 'College / School',
                              icon: Icons.school,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) => value.isEmpty
                                  ? 'College name can\'t be empty'
                                  : null,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: RoundedInputField(
                              formKey: _locationFormKey,
                              onChanged: (value) {
                                setState(() {
                                  _location = value;
                                });
                              },
                              textCapitalization: TextCapitalization.words,
                              hintText: 'Campus Location',
                              icon: Icons.location_city,
                              validator: (value) => value.isEmpty
                                  ? 'Campus location can\'t be empty'
                                  : null,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: RoundedInputField(
                              formKey: _courseFormKey,
                              onChanged: (value) {
                                setState(() {
                                  _course = value;
                                });
                              },
                              hintText: 'Course / Branch / Field / Class',
                              icon: Icons.book,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) => value.isEmpty
                                  ? 'Course can\'t be empty'
                                  : null,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: RoundedButton(
                              text: 'Continue',
                              textColor: Colors.white,
                              color: kButtonColor,
                              onPress: () {
                                if (_nameFormKey.currentState.validate() &&
                                    _collegeFormKey.currentState.validate() &&
                                    _locationFormKey.currentState.validate() &&
                                    _courseFormKey.currentState.validate()) {
                                  updateDetails(
                                    _name,
                                    _college,
                                    _location,
                                    _course,
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
