import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField, String uid) {
    return Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .where('title', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
