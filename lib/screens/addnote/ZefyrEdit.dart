import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';

class ZefyrNote extends StatefulWidget {
  // final Note note;
  final String contents;
  final DatabaseService databaseService;
  final UserRepository userRepository;
  const ZefyrNote(
      {Key key,
      // this.note,
      this.contents,
      @required this.databaseService,
      @required this.userRepository})
      : super(key: key);

  @override
  _ZefyrNoteState createState() => _ZefyrNoteState();
}

class _ZefyrNoteState extends State<ZefyrNote> {
  Color mainColor = Colors.white;
  final appBarIconColor = Colors.black;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // StreamSubscription<NotusChange> _sub;

  _save() async {
    print('savvvvinggg....');

//
//
//
    var contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents);
//
//
//

    contents = jsonEncode(_controller.document.toJson());

    Toast.show('Saving note...', context, duration: 100);
    if (await _checkConnection()) {
      await widget.databaseService.createZefyrUserData(contents: contents);
      Toast.show('Note saves sucessfully', context);
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return HomeScreen(userRepository: widget.userRepository);
      }));
    } else {
      Toast.show('Network Error', context);
    }
  }

  ZefyrController _controller;
  Future<NotusDocument> _loadDocument() async {
    // final file = File(Directory.systemTemp.path + "/quick_start.json");
    // if (await file.exists()) {
    //   final contents = await file.readAsString();
    //   return NotusDocument.fromJson(jsonDecode(contents));
    // }
    print('contents............' + widget.contents == null ? false : true);
    if (widget.contents == null) {
      return NotusDocument.fromJson(jsonDecode(widget.contents));
    } else {
      final Delta delta = Delta()..insert('Add your Note\n');
      return NotusDocument.fromDelta(delta);
    }
  }

  FocusNode _focusNode;

  Future<bool> _onBackPressed() {
    FocusScope.of(context).unfocus();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to save your note ?',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (BuildContext context) {
                return HomeScreen(userRepository: widget.userRepository);
              }));
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () async {
              await _save();
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (BuildContext context) {
                return HomeScreen(userRepository: widget.userRepository);
              }));
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  bool _showNetworkError = false;

  Future<bool> _checkConnection() async {
    if (await DataConnectionChecker().hasConnection) {
      setState(() {
        _showNetworkError = false;
      });
      return true;
    } else {
      setState(() {
        print('netwrok error');
        _showNetworkError = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
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
              autofocus: false,
              controller: _controller,
              focusNode: _focusNode,
              physics: BouncingScrollPhysics(),
              imageDelegate: MyZefyrImageDelegate(),
            ),
          );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldkey,
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
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => {
                _save(),
              },
            ),
          ],
        ),
        body: body,
      ),
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
