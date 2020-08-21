import 'dart:io';
import 'package:meta/meta.dart';

class Note {
  String note;
  String dateTime;
  bool bold;
  bool italic;
  bool uderlined;
  bool strikeThrough;
  bool textHigh;
  String color;
  List<File> images;
  //TODO: add drawModel maybe by using maps
  String alignment;
  Note(
      {@required this.note,
      @required this.dateTime,
      this.bold,
      this.italic,
      this.uderlined,
      this.strikeThrough,
      this.textHigh,
      this.color,
      this.images});
}
