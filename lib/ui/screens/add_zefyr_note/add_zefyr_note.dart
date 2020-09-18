import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notado/global/enums/enums.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/screens/add_zefyr_note/bloc/zefyr_bloc.dart';
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

  _save() {}

  _update() {}

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
    var noteMode = Provider.of<NoteModeProvider>(context, listen: false);

    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrTheme(
            data: ZefyrThemeData(
              toolbarTheme: ToolbarTheme.fallback(context).copyWith(
                color: Colors.white,
                iconColor: Colors.purple,
              ),
            ),
            child: ZefyrScaffold(
              child: ZefyrEditor(
                autofocus: false,
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
        key: _scaffoldkey,
        appBar: AppBar(),
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

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    return file.path.toString();
  }
}
