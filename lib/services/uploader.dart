import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Uploader {
  FirebaseStorage _firebaseStorage =
      FirebaseStorage(storageBucket: 'gs://studopedia-16.appspot.com');

  Future<String> uploadPic(File file, String uid, String imagePath) async {
    String fileName = 'dp/$uid/${basename(imagePath)}';
    StorageUploadTask uploadTask =
        _firebaseStorage.ref().child(fileName).putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String imageUrl =
        await _firebaseStorage.ref().child(fileName).getDownloadURL();
    return imageUrl;
  }

  Future<void> deleteFile(String uid, String url) async {
    await _firebaseStorage
        .getReferenceFromUrl(url)
        .then((value) => value.delete())
        .catchError((e) => print(e));
  }
}
