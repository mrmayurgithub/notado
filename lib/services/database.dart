import 'package:notado/models/note_model.dart';
import 'package:notado/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notado/packages/packages.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  final CollectionReference noteReference =
      Firestore.instance.collection('notes');
  final CollectionReference trashReference =
      Firestore.instance.collection('trash');

  Future<void> createUserData(
    // String id,
    String title,
    String content,
    String dateTime,
    bool bold,
    bool italic,
    bool underlined,
    bool strikeThrough,
    bool textHigh,
    String alignment,
    String noteColor,
    String modifiedAt,
    String drawPoints,
    String drawColor,
  ) async {
    final id = Firestore.instance.collection('notes').document().documentID;
    return await noteReference.document(id).setData({
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'bold': bold,
      'italic': italic,
      'underlined': underlined,
      'strikeThrough': strikeThrough,
      'textHigh': textHigh,
      'alignment': alignment,
      'noteColor': noteColor,
      'modifiedAt': modifiedAt,
      'drawPoints': drawPoints,
      'drawColor': drawColor,
    });
  }

  Future<void> updateUserData(
    String id,
    String title,
    String content,
    String dateTime,
    bool bold,
    bool italic,
    bool underlined,
    bool strikeThrough,
    bool textHigh,
    String alignment,
    String noteColor,
    String modifiedAt,
    String drawPoints,
    String drawColor,
  ) async {
    return await noteReference.document(id).updateData({
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'bold': bold,
      'italic': italic,
      'underlined': underlined,
      'strikeThrough': strikeThrough,
      'textHigh': textHigh,
      'alignment': alignment,
      'noteColor': noteColor,
      'modifiedAt': modifiedAt,
      'drawPoints': drawPoints,
      'drawColor': drawColor,
    });
  }

  Future<void> deleteUserDataFromNotes(String id) async {
    return await noteReference
        .document(id)
        .delete()
        .whenComplete(() => print('DELETED FROM NOTES'));
  }

  Future<void> deleteUserDataFromTrash(String id) async {
    return await trashReference
        .document(id)
        .delete()
        .whenComplete(() => print('DELETED FROM TRASH'));
  }

  Future<void> trashUserData(
    String id,
    String title,
    String content,
    String dateTime,
    bool bold,
    bool italic,
    bool underlined,
    bool strikeThrough,
    bool textHigh,
    String alignment,
    String noteColor,
    String modifiedAt,
    String drawPoints,
    String drawColor,
  ) async {
    await trashReference.document(id).setData({
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'bold': bold,
      'italic': italic,
      'underlined': underlined,
      'strikeThrough': strikeThrough,
      'textHigh': textHigh,
      'alignment': alignment,
      'noteColor': noteColor,
      'modifiedAt': modifiedAt,
      'drawPoints': drawPoints,
      'drawColor': drawColor,
    });
    return deleteUserDataFromNotes(id);
  }

//TODO: CHECKKKKKKKKKkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
  //Note list from snapshot
  List<Note> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((docuid) {
      return Note(
        title: docuid.data['title'] ?? '',
        content: docuid.data['content'] ?? '',
        dateTime: docuid.data['dateTime'] ?? '',
        bold: docuid.data['bold'] ?? true,
        italic: docuid.data['italic'] ?? false,
        underlined: docuid.data['underlined'] ?? false,
        strikeThrough: docuid.data['strikeThrough'] ?? false,
        textHigh: docuid.data['textHigh'] ?? false,
        alignment: docuid.data['alignment'] ?? '',
        noteColor: docuid.data['noteColor'] ?? 'black',
        createdAt: docuid.data['createdAt'] ?? '',
        modifiedAt: docuid.data['modifiedAt'] ?? '',
        drawPoints: docuid.data['drawPoints'] ?? '',
        drawColor: docuid.data['drawColor'] ?? 'blue',
      );
    }).toList();
  }
  // // user data from snapshots
  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //     uid: uid,
  //     name: snapshot.data['name'],
  //     sugars: snapshot.data['sugars'],
  //     strength: snapshot.data['strength']
  //   );
  // }

  // get brews stream
  Stream<List<Note>> get notes {
    return noteReference.snapshots().map(_noteListFromSnapshot);
  }

  // // get user doc stream
  // Stream<UserData> get userData {
  //   return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
