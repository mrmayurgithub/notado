import 'dart:convert';
import 'package:meta/meta.dart';

class Note {
  Note({
    @required this.title,
    @required this.date,
    this.contents,
    this.id,
    this.searchKey,
  });

  final String title;
  final String date;
  String contents;
  String searchKey;
  String id;

  static Note allFromResponse(String response) {
    var decodedJson = json.decode(response);
    return decodedJson['contents']
        .cast<Map<String, dynamic>>()
        .map((obj) => Note.fromMap(obj))
        .toList()
        .cast<Note>();
  }

  static Note fromMap(Map map) {
    return Note(
      title: map['title'],
      date: map['date'],
    );
  }
}

//###################################################################
//###################################################################
//###################################################################
//###################################################################

// static List<Note> allFromResponse(String response) {
//   //1
//   var decodedJson = json.decode(response).cast<String, dynamic>(); //2

//   return decodedJson['results']
//       .cast<Map<String, dynamic>>()
//       .map((obj) => Note.fromMap(obj)) //3
//       .toList()
//       .cast<Note>(); //4
// }

// static Note fromMap(Map map) {
//   var textJson = json.encode(map['text']); //5
//   return Note(
//     //6
//     title: map['title'],
//     text: textJson,
//     date: DateTime.parse(map['date']), //7
//   );
// }
