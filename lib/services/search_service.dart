import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField, String uid) {
    print('uid..uid....................' + uid.toString());
    return Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
