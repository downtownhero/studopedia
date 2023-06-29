import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/user_data.dart';

class FollowersList {
  List<UserData> followers = List<UserData>();
  FollowersList.fromSnapshot(DocumentSnapshot snapshot) {
    followers = snapshot['following'].map<UserData>((data) {
      return UserData.fromMap(data);
    }).toList();
  }
}
