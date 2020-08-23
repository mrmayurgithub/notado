import 'dart:io';
import 'package:meta/meta.dart';

class Note {
  String title;
  String content;
  String dateTime;
  bool bold;
  bool italic;
  bool underlined;
  bool strikeThrough;
  bool textHigh;
  String alignment;
  String noteColor;
  final String createdAt;
  String modifiedAt;
  //TODO:
  // List<File> images;
  String drawPoints;
  String drawColor;
  Note({
    @required this.title,
    @required this.content,
    @required this.dateTime,
    @required this.bold,
    @required this.italic,
    @required this.underlined,
    @required this.strikeThrough,
    @required this.textHigh,
    @required this.alignment,
    @required this.noteColor,
    // @required this.images,
    @required this.createdAt,
    @required this.modifiedAt,
    @required this.drawPoints,
    @required this.drawColor,
  });
}
