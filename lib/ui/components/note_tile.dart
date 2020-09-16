import 'package:flutter/material.dart';
import 'package:notado/global/constants.dart';

class NoteTile extends StatefulWidget {
  final String title;
  final String contents;
  final String id;
  final String date;
  final String searchKey;
  NoteTile({
    @required this.title,
    @required this.contents,
    @required this.id,
    @required this.date,
    @required this.searchKey,
  })  : assert(title != null),
        assert(id != null),
        assert(date != null),
        assert(searchKey != null);
  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // borderRadius: buttonBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.04),
            offset: Offset(0.0, 5.0),
            blurRadius: 10,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: ListTile(
        // contentPadding: EdgeInsets.symmetric(
        //     horizontal: screenWidth * 0.02, vertical: screenHeight * 0.010),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(widget.date),
      ),
    );
  }
}
