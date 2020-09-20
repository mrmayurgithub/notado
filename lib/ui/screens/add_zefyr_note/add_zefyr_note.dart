import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notado/global/database_helper/database_helper.dart';
import 'package:notado/global/enums/enums.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/screens/add_zefyr_note/bloc/zefyr_bloc.dart';
import 'package:notado/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

// class ZefyrNote extends StatefulWidget {
//   @override
//   _ZefyrNoteState createState() => _ZefyrNoteState();
// }

// class _ZefyrNoteState extends State<ZefyrNote> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ZefyrBloc(),
//       child: ZefyrMainPage(),
//     );
//   }
// }

// class ZefyrMainPage extends StatefulWidget {
//   final Note note;
//   const ZefyrMainPage({Key key, this.note}) : super(key: key);
//   @override
//   _ZefyrMainPageState createState() => _ZefyrMainPageState();
// }

// class _ZefyrMainPageState extends State<ZefyrMainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ZefyrBloc, ZefyrState>(
//       listener: (context, state) {
//         if (state is ZefyrError) {
//           Toast.show(state.message.toString(), context);
//         }
//         if (state is UpdateSuccess) {
//           Navigator.of(context).pop();
//           Toast.show('Updated', context);
//         }
//         if (state is CreateSuccess) {}
//         if (state is CreateLoading) {
//           Toast.show('Creating note...', context);
//         }
//         if (state is UpdateLoading) {
//           Toast.show('Updating...', context);
//         }
//         if (state is Cancelled) {}
//       },
//       builder: (context, state) {
//         return Consumer<NoteModeProvider>(
//           builder: null,
//         );
//       },
//     );
//   }
// }
class ZefyrNote extends StatefulWidget {
  final NotusDocument contents;
  final String id;
  final String title;
  final String date;
  final String searchKey;
  ZefyrNote({
    this.contents,
    this.date,
    this.id,
    this.searchKey,
    this.title,
  });

  @override
  _ZefyrNoteState createState() => _ZefyrNoteState();
}

class _ZefyrNoteState extends State<ZefyrNote> {
  ZefyrController _controller;
  FocusNode _focusNode;
  TextEditingController _titleController;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<NotusDocument> _loadDocument() async {
    var notemodeC = Provider.of<NoteModeProvider>(context, listen: false);
    if (notemodeC.notemode == zefyrNoteMode.editNote) {
      _titleController.text = widget.title;
      return widget.contents;
    }
    _titleController.text = 'Untitled Note';
    final Delta delta = Delta()..insert('Type here\n');
    return NotusDocument.fromDelta(delta);
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
        _showNetworkError = true;
      });
      return false;
    }
  }

  _save() async {
    var dateTime = DateTime.now().toString();
    var dateParse = DateTime.parse(dateTime);
    var date = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var contents = jsonEncode(_controller.document.toJson());
    Toast.show('Saving note', context, duration: 100);
    if (await _checkConnection()) {
      //TODO: createdatabase
      // BlocProvider.of<HomepageBloc>(context).add(
      //   CreateNote(
      //     contents: contents,
      //     date: date,
      //     searchKey: _titleController.text[0],
      //     title: _titleController.text,
      //   ),
      // );
      DatabaseHelper.createZefyrUserData(
        contents: contents,
        title: _titleController.text,
        date: date,
        searchKey: _titleController.text[0],
      );
      Toast.show('Note Saved', context);
      await getNotesFromNotesOBName();
      Navigator.of(context).pushReplacementNamed('Home');
    } else {
      Navigator.of(context).pop();
      Toast.show('Network Error', context);
    }
  }

  _update() async {
    var datetime = DateTime.now().toString();
    var dateParse = DateTime.parse(datetime);
    var date = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var contents = jsonEncode(_controller.document.toJson());
    Toast.show('Updating note', context, duration: 100);
    if (await _checkConnection()) {
      //TODO: implement update note
      // BlocProvider.of<HomepageBloc>(context).add(
      //   UpdateNote(
      //     contents: contents,
      //     date: date,
      //     id: widget.id,
      //     searchKey: _titleController.text[0],
      //     title: _titleController.text,
      //   ),
      // );
      DatabaseHelper.updateZefyrUserData(
        contents: contents,
        title: _titleController.text,
        date: date,
        searchKey: _titleController.text[0],
        id: widget.id,
      );
      Toast.show('Note updated', context);
      await getNotesFromNotesOBName();
      Navigator.of(context).pushReplacementNamed('Home');
    } else {
      Navigator.of(context).pop();
      Toast.show('Network Error', context);
    }
  }

  Future<bool> _onBackPressed() {
    // if (_controller.document == null) {
    //   Navigator.pop(context);
    // }
    // getNotesFromNotesOBName();

    FocusScope.of(context).unfocus();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to save your note ?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('Home');
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {},
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _titleController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _titleController.text = 'Untitled Note';
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var noteModeEEE = Provider.of<NoteModeProvider>(context, listen: false);

    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrTheme(
            data: ZefyrThemeData(
              // defaultLineTheme: LineTheme(
              //   textStyle: TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
              toolbarTheme: ToolbarTheme.fallback(context).copyWith(
                  // color: Colors.black,
                  // iconColor: Colors.white,
                  ),
            ),
            child: ZefyrScaffold(
              child: ZefyrEditor(
                // autofocus: false,
                physics: BouncingScrollPhysics(),
                imageDelegate: MyZefyrImageDelegate(),
                controller: _controller,
                focusNode: _focusNode,
              ),
            ),
          );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldkey,
        appBar: AppBar(
          actionsIconTheme:
              Theme.of(context).iconTheme.copyWith(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: TextFormField(
            controller: _titleController,
            decoration: InputDecoration.collapsed(
              hintText: 'Title',
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Save Note',
              icon: noteModeEEE.notemode == zefyrNoteMode.newNote
                  ? Icon(Icons.check)
                  : Icon(Icons.done),
              onPressed: () {
                noteModeEEE.notemode == zefyrNoteMode.newNote
                    ? _save()
                    : _update();
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
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;
  @override
  ImageSource get gallerySource => ImageSource.gallery;

  // @override
  // Future<String> pickImage(ImageSource source) async {
  //   final file = await picker.getImage(source: source);
  //   if (file == null) return null;
  //   return file.path.toString();
  // }
  @override
  Future<String> pickImage(ImageSource source) async {
    final image = await picker.getImage(source: source) as File;
    if (image == null) return null;
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask =
        ref.putFile(image, StorageMetadata(contentType: 'image/jpeg'));
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return getImageUrl(storageTaskSnapshot);
  }

  Future getImageUrl(StorageTaskSnapshot snapshot) {
    return snapshot.ref.getDownloadURL().then((value) => value);
  }
}
