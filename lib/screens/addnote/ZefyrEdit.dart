import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';

class ZefyrNote extends StatefulWidget {
  final Note note;
  final DatabaseService databaseService;
  final UserRepository userRepository;
  const ZefyrNote(
      {Key key, this.note, this.databaseService, this.userRepository})
      : super(key: key);

  @override
  _ZefyrNoteState createState() => _ZefyrNoteState();
}

class _ZefyrNoteState extends State<ZefyrNote> {
  Color mainColor = Colors.white;
  final appBarIconColor = Colors.black;
  // StreamSubscription<NotusChange> _sub;
  String uid;
  DatabaseService databaseService;

  _save() async {
    final contents = jsonEncode(_controller.document);

    databaseService.createZefyrUserData(contents: contents);
  }

  getUid() async {
    uid = widget.userRepository.getUID().toString();
  }

  ZefyrController _controller;
  Future<NotusDocument> _loadDocument() async {
    final Delta delta = Delta()..insert('Add your Note\n');
    return NotusDocument.fromDelta(delta);
  }

  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    getUid();
    databaseService = DatabaseService(uid: uid);
    _focusNode = FocusNode();
    // _sub = _controller.document.changes.listen((change) {
    //   print('${change.source}: ${change.change}');
    // });
    // _controller = ZefyrController(NotusDocument.fromDelta(
    //     Delta.fromJson(json.decode(widget.note.text) as List))); //1

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
              imageDelegate: MyZefyrImageDelegate(),
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
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: null),
        ],
      ),
      body: body,
    );
  }
}

class MyZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final picker = ImagePicker();

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    return file.path.toString();
    //TODO: implement image storage in cloud storage
  }
}
