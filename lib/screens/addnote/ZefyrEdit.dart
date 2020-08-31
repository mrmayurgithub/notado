import 'package:flutter/material.dart';
import 'package:notado/packages/packages.dart';

class ZefyrNote extends StatefulWidget {
  @override
  _ZefyrNoteState createState() => _ZefyrNoteState();
}

class _ZefyrNoteState extends State<ZefyrNote> {
  Color mainColor = Colors.white;
  final appBarIconColor = Colors.black;

  ZefyrController _controller;
  Future<NotusDocument> _loadDocument() async {
    final Delta delta = Delta()..insert('Add your Note\n');
    return NotusDocument.fromDelta(delta);
  }

  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
              physics: BouncingScrollPhysics(),
              imageDelegate: MyAppZefyrImageDelegate(),
            ),
          );
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: mainColor,
        title: Text(
          'Add your Note',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: appBarIconColor,
          ),
        ),
      ),
      body: body,
    );
  }
}
