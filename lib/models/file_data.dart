import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/user_files.dart';

class FileData {
  String uid;
  List<UserFiles> userFiles = List<UserFiles>();

  FileData.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.documentID;
    userFiles = snapshot['files'].map<UserFiles>((data) {
      return UserFiles.fromMap(data);
    }).toList();
  }
}
