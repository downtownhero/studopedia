import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String fullName;
  String uid;
  String email;
  String college;
  String campus;
  String course;
  String imageUrl;
  List searchData;

  UserData({
    this.uid,
    this.email,
    this.fullName,
    this.college,
    this.campus,
    this.course,
    this.imageUrl,
    this.searchData,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      uid: doc.documentID,
      email: doc['email'],
      fullName: doc['fullName'],
      college: doc['college'],
      course: doc['course'],
      campus: doc['campus'],
      imageUrl: doc['imageUrl'],
      searchData: doc['searchData'].toList(),
    );
  }
  UserData.fromMap(Map<dynamic, dynamic> data)
      : uid = data['uid'],
        email = data['email'],
        fullName = data['fullName'],
        college = data['college'],
        course = data['course'],
        campus = data['campus'],
        imageUrl = data['imageUrl'];
}
