// import 'dart:io';
// import 'package:meta/meta.dart';

// class Note {
//   String title;
//   String content;
//   String dateTime;
//   bool bold;
//   bool italic;
//   bool underlined;
//   bool strikeThrough;
//   bool textHigh;
//   String alignment;
//   String noteColor;
//   final String createdAt;
//   String modifiedAt;
//   //TODO:
//   // List<File> images;
//   String drawPoints;
//   String drawColor;
//   Note({
//     @required this.title,
//     @required this.content,
//     @required this.dateTime,
//     @required this.bold,
//     @required this.italic,
//     @required this.underlined,
//     @required this.strikeThrough,
//     @required this.textHigh,
//     @required this.alignment,
//     @required this.noteColor,
//     // @required this.images,
//     @required this.createdAt,
//     @required this.modifiedAt,
//     @required this.drawPoints,
//     @required this.drawColor,
//   });
// }
import 'dart:convert';

import 'package:meta/meta.dart';

class Note {
  Note({
    @required this.title,
    @required this.text,
    @required this.date,
  });

  final String title;
  String text;
  final DateTime date;

  

  static List<Note> allFromResponse(String response) {
    //1
    var decodedJson = json.decode(response).cast<String, dynamic>(); //2

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Note.fromMap(obj)) //3
        .toList()
        .cast<Note>(); //4
  }

  static Note fromMap(Map map) {
    var textJson = json.encode(map['text']); //5
    return new Note(
      //6
      title: map['title'],
      text: textJson,
      date: DateTime.parse(map['date']), //7
    );
  }
}
