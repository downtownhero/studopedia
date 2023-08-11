import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studopedia/models/save_later.dart';
import 'package:studopedia/models/user_data.dart';
import 'package:studopedia/models/user_file.dart';
import 'package:studopedia/screens/home_screen.dart';
import 'package:studopedia/screens/user_screen.dart';
import 'package:studopedia/services/database.dart';
import 'package:studopedia/models/file_data.dart';

class CurrentUser extends ChangeNotifier {
  UserData _currentUserData = UserData();
  UserFile _currentUserFile = UserFile();
  FileData _currentUserFileData;
  SaveLater _currentUserSaveLater;
  SaveLater get getCurrentUserSaveLater => _currentUserSaveLater;
  FileData get getCurrentUserFileData => _currentUserFileData;
  UserData get getCurrentUserData => _currentUserData;
  UserFile get getCurrentUserFile => _currentUserFile;

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> fileList = List<Map<String, dynamic>>();

  Future<String> signUpUser(String email, String password) async {
    String returnValue = 'Error';

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      returnValue = 'Success';
    } catch (e) {
      returnValue = e.message;
    }
    return returnValue;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String returnValue = 'Error';

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUserData = await Database().getUserInfo(_authResult.user.uid);
      if (_currentUserData != null) {
        returnValue = 'Success';
      }
    } catch (e) {
      returnValue = e.message;
    }
    return returnValue;
  }

  Future<String> loginUserWithGoogle() async {
    String returnValue = 'Error';
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

      AuthResult _authResult = await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
//        _currentUserData.uid = _authResult.user.uid;
//        _currentUserData.email = _authResult.user.email;
        _currentUserData = await Database().getUserInfo(_authResult.user.uid);
        if (_currentUserData != null) {
          returnValue = 'newUser';
        }
      } else {
        _currentUserData = await Database().getUserInfo(_authResult.user.uid);
        if (_currentUserData != null) {
          returnValue = 'oldUser';
        }
      }
    } catch (e) {
      returnValue = e.message;
    }
    return returnValue;
  }

  Future<String> onStartUp() async {
    String returnValue = 'Error';
    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      _currentUserData = await Database().getUserInfo(_firebaseUser.uid);
      _currentUserFileData = UserScreen().currentUserData;
      _currentUserSaveLater = HomeScreen().currentUserSavedData;
      await Database().getStreams(_firebaseUser.uid);
      DocumentSnapshot snapshot = await Firestore.instance
          .collection('users')
          .document(_firebaseUser.uid)
          .get();
      if (_currentUserData != null && snapshot.data != null) {
        returnValue = 'Success';
      } else if (snapshot.data == null) {
        returnValue = 'IncompleteInfo';
      }
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> userDetails(String name, String college, String location,
      String course, String imageUrl, List<String> searchData) async {
    String returnValue = 'Error';
    UserData _user = UserData();
    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      _user.uid = _firebaseUser.uid;
      _user.email = _firebaseUser.email;
      _user.fullName = name.trim();
      _user.college = college.trim();
      _user.campus = location.trim();
      _user.course = course.trim();
      _user.imageUrl = imageUrl;
      _user.searchData = searchData;
      String returnString = await Database().createUser(_user);
      _currentUserData = await Database().getUserInfo(_firebaseUser.uid);
      if (returnString == 'Success' && _currentUserData != null) {
        returnValue = 'Success';
      }
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> signOut() async {
    String returnValue = 'Error';
    try {
      await _auth.signOut();
      _currentUserData = UserData();
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> userFile(String title, String des, String fileUrl,
      Map<String, dynamic> fileData) async {
    String returnValue = 'Error';
    UserFile _file = UserFile();
    fileList.add(fileData);
    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      _file.uid = _firebaseUser.uid;
      _file.title = title;
      _file.des = des;
      _file.fileUrl = fileUrl;
      _file.list = fileList;
      String returnString = await Database().userFile(_file);
      if (returnString == 'Success') {
        returnValue = 'Success';
      }
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> resetPassword(String email) async {
    String returnValue = 'Error';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }
}
