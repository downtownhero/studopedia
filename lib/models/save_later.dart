import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/user_files.dart';

class SaveLater {
  String uid;
  List<UserFiles> userFiles = List<UserFiles>();

  SaveLater.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.documentID;
    userFiles = snapshot['saveForLater'].map<UserFiles>((data) {
      return UserFiles.fromMap(data);
    }).toList();
  }
}
