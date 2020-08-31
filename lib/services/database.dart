import 'dart:io';

import 'package:notado/models/note_model.dart';
import 'package:notado/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notado/packages/packages.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  Future<void> createZefyrUserData({@required String contents}) async {
    final id = Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .document()
        .documentID;

    return await Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .document(id)
        .setData({'contents': contents, 'id': id});
    //TODO: add upload images function
  }

  Future<void> updateZefyrUserData(
      {@required String contents, @required String id}) async {
    return await Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .document(id)
        .updateData({});
    //TODO: update images thing
  }

  Future<void> deleteZefyrUserDataFromNotes(
      {@required String contents, @required String id}) async {
    trashZefyrUserData(contents: contents, id: id);
    return await Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .document(id)
        .delete()
        .whenComplete(() => print('Deleted'));
    //TODO: delete from trash
  }

  Future<void> deleteZefyrUserDataFromTrash({@required String id}) async {
    return await Firestore.instance
        .collection('trash')
        .document(uid)
        .collection('userNotes')
        .document(id)
        .delete()
        .whenComplete(() => print('Deleted From Trash'));
    //TODO: delete from trash
  }

  Future<void> trashZefyrUserData(
      {@required String contents, @required String id}) async {
    return await Firestore.instance
        .collection('trash')
        .document(uid)
        .collection('userNotes')
        .document(id)
        .setData({'contents': contents, 'id': id});
  }

//TODO: improve
  List<Note> _noteZefyrListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((docuid) {
      return Note(
        title: null,
        text: null,
        date: null,
      );
    });
  }

  Stream<List<Note>> get notesZefyrFromTrash {
    return Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .snapshots()
        .map(_noteZefyrListFromSnapshot);
  }

  Stream<List<Note>> get notesZefyrFromNotes {
    return Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .snapshots()
        .map(_noteZefyrListFromSnapshot);
  }
//   Future<void> createUserData({
//     // String id,
//     @required String title,
//     @required String content,
//     @required String dateTime,
//     @required bool bold,
//     @required bool italic,
//     @required bool underlined,
//     @required bool strikeThrough,
//     @required bool textHigh,
//     @required String alignment,
//     @required String noteColor,
//     @required String modifiedAt,
//     @required String drawPoints,
//     @required String drawColor,
//     @required List<File> images,
//   }) async {
//     final id = Firestore.instance
//         .collection('notes')
//         .document(uid)
//         .collection('userNotes')
//         .document()
//         .documentID;

//     await Firestore.instance
//         .collection('notes')
//         .document(uid)
//         .collection('userNotes')
//         .document(id)
//         .setData({
//       'id': id,
//       'title': title,
//       'content': content,
//       'dateTime': dateTime,
//       'bold': bold,
//       'italic': italic,
//       'underlined': underlined,
//       'strikeThrough': strikeThrough,
//       'textHigh': textHigh,
//       'alignment': alignment,
//       'noteColor': noteColor,
//       'modifiedAt': modifiedAt,
//       'drawPoints': drawPoints,
//       'drawColor': drawColor,
//     });
//     return await uploadFileToNote(
//       images: images,
//       uid: uid,
//       id: id,
//     ).whenComplete(
//       () => print('Image uploaded'),
//     );
//   }

//   Future<void> updateUserData(
//     String id,
//     String title,
//     String content,
//     String dateTime,
//     bool bold,
//     bool italic,
//     bool underlined,
//     bool strikeThrough,
//     bool textHigh,
//     String alignment,
//     String noteColor,
//     String modifiedAt,
//     String drawPoints,
//     String drawColor,
//   ) async {
//     return await Firestore.instance
//         .collection('notes')
//         .document(uid)
//         .collection('userNotes')
//         .document(id)
//         .updateData({
//       'id': id,
//       'title': title,
//       'content': content,
//       'dateTime': dateTime,
//       'bold': bold,
//       'italic': italic,
//       'underlined': underlined,
//       'strikeThrough': strikeThrough,
//       'textHigh': textHigh,
//       'alignment': alignment,
//       'noteColor': noteColor,
//       'modifiedAt': modifiedAt,
//       'drawPoints': drawPoints,
//       'drawColor': drawColor,
//     });
//   }

//   Future<void> deleteUserDataFromNotes(String id) async {
//     return await Firestore.instance
//         .collection('notes')
//         .document(uid)
//         .collection('userNotes')
//         .document(id)
//         .delete()
//         .whenComplete(() => print('DELETED FROM NOTES'));
//   }

//   Future<void> deleteUserDataFromTrash(String id) async {
//     return await Firestore.instance
//         .collection('trash')
//         .document(uid)
//         .collection('userNotes')
//         .document(id)
//         .delete()
//         .whenComplete(() => print('DELETED FROM TRASH'));
//     // return await trashReference
//     //     .document(id)
//     //     .delete()
//     //     .whenComplete(() => print('DELETED FROM TRASH'));
//   }

//   Future<void> trashUserData(
//     String id,
//     String title,
//     String content,
//     String dateTime,
//     bool bold,
//     bool italic,
//     bool underlined,
//     bool strikeThrough,
//     bool textHigh,
//     String alignment,
//     String noteColor,
//     String modifiedAt,
//     String drawPoints,
//     String drawColor,
//   ) async {
//     return await Firestore.instance
//         .collection('trash')
//         .document(uid)
//         .collection('userNotes')
//         .document(id)
//         .setData({
//       // await trashReference.document(id).setData({
//       'id': id,
//       'title': title,
//       'content': content,
//       'dateTime': dateTime,
//       'bold': bold,
//       'italic': italic,
//       'underlined': underlined,
//       'strikeThrough': strikeThrough,
//       'textHigh': textHigh,
//       'alignment': alignment,
//       'noteColor': noteColor,
//       'modifiedAt': modifiedAt,
//       'drawPoints': drawPoints,
//       'drawColor': drawColor,
//     });
//     return deleteUserDataFromNotes(id);
//   }

// //TODO: CHECKKKKKKKKKkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
//   //Note list from snapshot
//   //TODO: check
//   List<Note> _noteListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.documents.map((docuid) {
//       return Note(
//         title: docuid.data['title'] ?? '',
//         content: docuid.data['content'] ?? '',
//         dateTime: docuid.data['dateTime'] ?? '',
//         bold: docuid.data['bold'] ?? true,
//         italic: docuid.data['italic'] ?? false,
//         underlined: docuid.data['underlined'] ?? false,
//         strikeThrough: docuid.data['strikeThrough'] ?? false,
//         textHigh: docuid.data['textHigh'] ?? false,
//         alignment: docuid.data['alignment'] ?? '',
//         noteColor: docuid.data['noteColor'] ?? 'black',
//         createdAt: docuid.data['createdAt'] ?? '',
//         modifiedAt: docuid.data['modifiedAt'] ?? '',
//         drawPoints: docuid.data['drawPoints'] ?? '',
//         drawColor: docuid.data['drawColor'] ?? 'blue',
//       );
//     }).toList();
//   }
//   // // user data from snapshots
//   // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//   //   return UserData(
//   //     uid: uid,
//   //     name: snapshot.data['name'],
//   //     sugars: snapshot.data['sugars'],
//   //     strength: snapshot.data['strength']
//   //   );
//   // }

//   Stream<List<Note>> get notesFromNotes {
//     return Firestore.instance
//         .collection('notes')
//         .document(uid)
//         .collection('userNotes')
//         .snapshots()
//         .map(_noteListFromSnapshot);
//   }

//   Stream<List<Note>> get notesFromTrash {
//     return Firestore.instance
//         .collection('trash')
//         .document(uid)
//         .collection('userNotes')
//         .snapshots()
//         .map(_noteListFromSnapshot);
//   }

//   String _uploadFileURL;
//   String fileURL;
//   Future uploadFileToNote(
//       {@required List<File> images, @required String uid, @required id}) async {
//     for (int i = 0; i < images.length; i++) {
//       StorageUploadTask uploadTask = Fire   baseStorage.instance
//           .ref()
//           .child('notes/$uid/$id')
//           .putFile(images[i]);

//       await uploadTask.onComplete;
//       print('File uploaded');
//       // FirebaseStorage.instance.ref().child('notes/$uid/$id}').getDownloadURL();
//     }
//   }

//   Future uploadFileToNTrash(List<File> images) async {
//     for (int i = 0; i < images.length; i++) {
//       StorageReference storageReference =
//           FirebaseStorage.instance.ref().child('');
//       StorageUploadTask uploadTask = storageReference.putFile(images[i]);
//       await uploadTask.onComplete;
//       print('File uploaded');
//       storageReference.getDownloadURL();
//     }
//   }

//   // // get user doc stream
//   // Stream<UserData> get userData {
//   //   return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
//   // }
}

class dataUploadModel {
  String contents;
  String id;
}
