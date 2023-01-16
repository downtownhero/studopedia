import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studopedia/models/notes_list.dart';
import 'package:studopedia/models/save_later.dart';
import 'package:studopedia/models/user_data.dart';
import 'package:studopedia/models/user_file.dart';
import 'package:studopedia/services/uploader.dart';

class Database {
  Firestore _firestore = Firestore.instance;
  Map<String, dynamic> mapFile;
  List fileList = List();
  Future<String> createUser(UserData user) async {
    String returnValue = 'error';
    try {
      await _firestore.collection('users').document(user.uid).setData({
        'fullName': user.fullName,
        'email': user.email,
        'college': user.college,
        'campus': user.campus,
        'course': user.course,
        'imageUrl': user.imageUrl,
        'searchData': user.searchData,
      });
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<UserData> getUserInfo(String uid) async {
    UserData returnValue = UserData();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').document(uid).get();
      returnValue.uid = uid;
      returnValue.fullName = _docSnapshot.data['fullName'];
      returnValue.college = _docSnapshot.data['college'];
      returnValue.campus = _docSnapshot.data['campus'];
      returnValue.course = _docSnapshot.data['course'];
      returnValue.email = _docSnapshot.data['email'];
      returnValue.imageUrl = _docSnapshot.data['imageUrl'];
      returnValue.searchData = _docSnapshot.data['searchData'];
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> userFile(UserFile file) async {
    String returnValue = 'error';
    mapFile = {
      'title': file.title,
      'des': file.des,
      'fileUrl': file.fileUrl,
    };
    try {
      await _firestore.collection('userFile').document(file.uid).setData(
        {
          'files': FieldValue.arrayUnion([mapFile]),
        },
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateName(String name, String uid, String oldName) async {
    String returnValue = 'error';
    print(oldName);
    print(name);
    List oldNameSplit = oldName.split(' ');
    List newNameSplit = name.split(' ');
    List newSearchList = [];
    List oldSearchList = [];
    String newText = newNameSplit[0];
    for (int i = 1; i < newNameSplit.length; i++) {
      newText = '$newText ${newNameSplit[i]}';
      newSearchList.add(newText);
    }
    String oldText = oldNameSplit[0];
    for (int i = 1; i < oldNameSplit.length; i++) {
      oldText = '$oldText ${oldNameSplit[i]}';
      oldSearchList.add(oldText);
    }
    for (int i = 0; i < newNameSplit.length; i++) {
      for (int j = 0; j < newNameSplit[i].length + 1; j++) {
        newSearchList.add(newNameSplit[i].substring(0, j));
      }
    }
    try {
      await _firestore
          .collection('users')
          .document(uid)
          .updateData({'fullName': name});
      for (int i = 0; i < oldNameSplit.length; i++) {
        for (int j = 0; j < oldNameSplit[i].length + 1; j++) {
          await _firestore.collection('users').document(uid).setData(
            {
              'searchData':
                  FieldValue.arrayRemove([oldNameSplit[i].substring(0, j)]),
            },
            merge: true,
          );
        }
      }
      for (int i = 0; i < oldSearchList.length; i++) {
        await _firestore.collection('users').document(uid).setData(
          {
            'searchData': FieldValue.arrayRemove([oldSearchList[i]]),
          },
          merge: true,
        );
      }
      await _firestore.collection('users').document(uid).setData(
        {'searchData': FieldValue.arrayUnion(newSearchList)},
        merge: true,
      );

      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateCollege(
      String college, String uid, String oldCollege) async {
    String returnValue = 'error';
    List<String> oldCollegeSplit = oldCollege.split(' ');
    List<String> newCollegeSplit = college.split(' ');
    List<String> newSearchList = [];
    List oldSearchList = [];
    String newText = newCollegeSplit[0];
    for (int i = 1; i < newCollegeSplit.length; i++) {
      newText = '$newText ${newCollegeSplit[i]}';
      newSearchList.add(newText);
    }
    String oldText = oldCollegeSplit[0];
    for (int i = 1; i < oldCollegeSplit.length; i++) {
      oldText = '$oldText ${oldCollegeSplit[i]}';
      oldSearchList.add(oldText);
    }

    for (int i = 0; i < newCollegeSplit.length; i++) {
      for (int j = 0; j < newCollegeSplit[i].length + 1; j++) {
        newSearchList.add(newCollegeSplit[i].substring(0, j));
      }
    }
    try {
      await _firestore
          .collection('users')
          .document(uid)
          .updateData({'college': college});
      for (int i = 0; i < oldCollegeSplit.length; i++) {
        for (int j = 0; j < oldCollegeSplit[i].length + 1; j++) {
          await _firestore.collection('users').document(uid).setData(
            {
              'searchData':
                  FieldValue.arrayRemove([oldCollegeSplit[i].substring(0, j)])
            },
            merge: true,
          );
        }
      }
      for (int i = 0; i < oldSearchList.length; i++) {
        await _firestore.collection('users').document(uid).setData(
          {
            'searchData': FieldValue.arrayRemove([oldSearchList[i]]),
          },
          merge: true,
        );
      }

      await _firestore.collection('users').document(uid).setData(
        {'searchData': FieldValue.arrayUnion(newSearchList)},
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateCampus(String campus, String uid) async {
    String returnValue = 'error';
    try {
      _firestore
          .collection('users')
          .document(uid)
          .updateData({'campus': campus});
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateCourse(String course, String uid) async {
    String returnValue = 'error';
    try {
      _firestore
          .collection('users')
          .document(uid)
          .updateData({'course': course});
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateImageUrl(String imageUrl, String uid) async {
    String returnValue = 'error';
    try {
      _firestore
          .collection('users')
          .document(uid)
          .updateData({'imageUrl': imageUrl});
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> updateListTitle(
      String newTitle, String uid, String oldTitle) async {
    String returnValue = 'error';
    List list = [];
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('userNoteslist').document(uid).get();
      list = documentSnapshot.data[oldTitle].toList();
      await _firestore
          .collection('userNoteslist')
          .document(uid)
          .setData({oldTitle: FieldValue.delete()}, merge: true);
      await _firestore.collection('userNoteslist').document(uid).setData(
        {newTitle: FieldValue.arrayUnion(list)},
        merge: true,
      );
      await _firestore.collection('userFile').document(uid).updateData({
        'notesList': FieldValue.arrayRemove([oldTitle])
      });
      await _firestore.collection('userFile').document(uid).updateData({
        'notesList': FieldValue.arrayUnion([newTitle])
      });
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> createNewList(
      {String uid,
      String listTitle,
      String title,
      String des,
      String fileUrl}) async {
    String returnValue = 'Error';
    var val = [];
    if (title != null && fileUrl != null) {
      var map = {'title': title, 'des': des, 'fileUrl': fileUrl};
      val.add(map);
    }
    try {
      await _firestore.collection('userNoteslist').document(uid).setData(
        {'$listTitle': FieldValue.arrayUnion(val)},
        merge: true,
      );
      await _firestore.collection('userFile').document(uid).setData(
        {
          'notesList': FieldValue.arrayUnion([listTitle])
        },
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> saveForLater(List newFile, String uid) async {
    String returnValue = 'Error';
    try {
      await _firestore.collection('userFile').document(uid).setData(
        {'saveForLater': FieldValue.arrayUnion(newFile)},
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<void> deleteFile(
      {String location,
      String uid,
      String collName,
      String title,
      String des,
      String fileUrl}) async {
    var val = [];
    var map = {'title': title, 'des': des, 'fileUrl': fileUrl};
    val.add(map);
    return await _firestore.collection(collName).document(uid).updateData({
      "$location": FieldValue.arrayRemove(val),
    });
  }

  Future<void> deleteMyFile(
      {String uid, String title, String des, String fileUrl}) async {
    var val = [];
    var map = {'title': title, 'des': des, 'fileUrl': fileUrl};
    val.add(map);
    await Uploader().deleteFile(uid, fileUrl);
    return await _firestore.collection('userFile').document(uid).updateData({
      'files': FieldValue.arrayRemove(val),
      'saveForLater': FieldValue.arrayRemove(val),
    });
  }

  Future getStreams(String uid) async {
    _firestore.collection('userFile').document(uid).get().then((querySnapshot) {
      try {
        SaveLater.fromSnapshot(querySnapshot);
      } catch (e) {
        print(e);
      }
    }).asStream();

    _firestore.collection('userFile').document(uid).get().then((querySnapshot) {
      try {
        NotesList.fromSnapshot(querySnapshot);
      } catch (e) {
        print(e);
      }
    }).asStream();
  }

  Future<List> notesListTitles(String uid) async {
    List titleList = [];
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('userFile').document(uid).get();
      titleList = snapshot.data['notesList'].toList();
    } catch (e) {
      print(e);
    }
    return titleList;
  }

  Future<void> deleteList(String uid, String title) async {
    try {
      await _firestore
          .collection('userNoteslist')
          .document(uid)
          .setData({title: FieldValue.delete()}, merge: true);
      await _firestore.collection('userFile').document(uid).updateData({
        'notesList': FieldValue.arrayRemove([title]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> follow(List newFollowing, String uid) async {
    String returnValue = 'Error';
    try {
      await _firestore.collection('users').document(uid).setData(
        {'following': FieldValue.arrayUnion(newFollowing)},
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<String> unFollow(List unFollow, String uid) async {
    String returnValue = 'Error';
    try {
      await _firestore.collection('users').document(uid).setData(
        {'following': FieldValue.arrayRemove(unFollow)},
        merge: true,
      );
      returnValue = 'Success';
    } catch (e) {
      print(e);
    }
    return returnValue;
  }

  Future<List> followers(String uid) async {
    List followersList = [];
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').document(uid).get();
      followersList = snapshot.data['following'].toList();
    } catch (e) {
      print(e);
    }
    return followersList;
  }
}
