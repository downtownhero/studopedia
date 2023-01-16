import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/user_files.dart';

class NoteslistData {
  String uid;
  List<UserFiles> userFiles = List<UserFiles>();

  NoteslistData.fromSnapshot(DocumentSnapshot snapshot, String listTitle) {
    uid = snapshot.documentID;
    userFiles = snapshot[listTitle].map<UserFiles>((data) {
      return UserFiles.fromMap(data);
    }).toList();
  }
}
