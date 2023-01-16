import 'package:cloud_firestore/cloud_firestore.dart';

class NotesList {
  String uid;
  List notesListTitle = List();

  NotesList.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.documentID;
    notesListTitle = snapshot['notesList'].toList();
  }
}
