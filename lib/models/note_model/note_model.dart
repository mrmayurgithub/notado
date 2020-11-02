import 'package:meta/meta.dart';

class Note {
  final String contents;
  final String title;
  final String date;
  final String id;
  final String searchKey;
  Note({
    @required this.contents,
    @required this.title,
    @required this.date,
    @required this.id,
    @required this.searchKey,
  });
}
