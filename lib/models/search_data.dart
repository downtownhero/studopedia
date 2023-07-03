import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/user_data.dart';

class SearchData {
  String uid;
  List<UserData> searchData = List<UserData>();

  SearchData.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.documentID;
    searchData =
        snapshot.data.map((key, value) => MapEntry(key, value)).values.toList();
  }
}
