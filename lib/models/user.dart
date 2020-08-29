import 'package:meta/meta.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  String title;
  String content;
  //TODO: Notestate for deleted and....
  String color;
  final String createdAt;
  String modifiedAt;

  UserData(
      {@required this.uid,
      @required this.title,
      @required this.content,
      @required this.color,
      @required this.createdAt,
      @required this.modifiedAt});
}
