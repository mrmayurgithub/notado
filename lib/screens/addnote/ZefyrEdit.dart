import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notado/enums/enums.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:intl/intl.dart';

// class ZefyrNote extends StatefulWidget {
//   // final Note note;

//   // final String contents;
//   // final String id;
//   final DatabaseService databaseService;
//   final UserRepository userRepository;
//   const ZefyrNote(
//       {Key key,
//       // this.id,
//       // this.contents,
//       @required this.databaseService,
//       @required this.userRepository})
//       : super(key: key);

//   @override
//   _ZefyrNoteState createState() => _ZefyrNoteState();
// }

// class _ZefyrNoteState extends State<ZefyrNote> {
//   Color mainColor = Colors.white;
//   final appBarIconColor = Colors.black;
//   final _scaffoldkey = GlobalKey<ScaffoldState>();
//   // StreamSubscription<NotusChange> _sub;
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
//   _save() async {
//     print('savvvvinggg....');

// //
// //
//     var contents = jsonEncode(_controller.document);
//     // For this example we save our document to a temporary file.
//     final file = File(Directory.systemTemp.path + "/quick_start.json");
//     // And show a snack bar on success.
//     file.writeAsString(contents);
// //
// //
//     contents = jsonEncode(_controller.document.toJson());
//     Toast.show('Saving note...', context, duration: 100);
//     if (await _checkConnection()) {
//       await widget.databaseService.createZefyrUserData(contents: contents);
//       Toast.show('Note saved sucessfully', context);
//       Navigator.pushReplacement(context,
//           CupertinoPageRoute(builder: (BuildContext context) {
//         return HomeScreen(userRepository: widget.userRepository);
//       }));
//     } else {
//       Toast.show('Network Error', context);
//     }
//   }

// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////
//   // _update() async {
//   //   print('updating.......');
//   //   //TODO: update on mobile data
//   //   var contents = jsonEncode(_controller.document.toJson());
//   //   Toast.show('Updating note...', context, duration: 100);
//   //   if (await _checkConnection()) {
//   //     await widget.databaseService
//   //         .updateZefyrUserData(contents: contents, id: widget.id);
//   //     Toast.show('Note updated sucessfully', context);
//   //     Navigator.pushReplacement(context,
//   //         CupertinoPageRoute(builder: (BuildContext context) {
//   //       return HomeScreen(userRepository: widget.userRepository);
//   //     }));
//   //   } else {
//   //     Toast.show('Network Error', context);
//   //   }
//   // }
// ///////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////

//   ZefyrController _controller;
//   Future<NotusDocument> _loadDocument() async {
//     // // final file = File(Directory.systemTemp.path + "/quick_start.json");
//     // // if (await file.exists()) {
//     // //   final contents = await file.readAsString();
//     // //   return NotusDocument.fromJson(jsonDecode(contents));
//     // // }
//     // return NotusDocument.fromJson(jsonDecode(widget.contents));

//     final Delta delta = Delta()..insert('Add your Note\n');
//     return NotusDocument.fromDelta(delta);
//   }

//   FocusNode _focusNode;

//   Future<bool> _onBackPressed() {
//     FocusScope.of(context).unfocus();
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Do you want to save your note ?',
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             onPressed: () {
//               Navigator.pushReplacement(context,
//                   CupertinoPageRoute(builder: (BuildContext context) {
//                 return HomeScreen(userRepository: widget.userRepository);
//               }));
//             },
//             child: Text('No'),
//           ),
//           FlatButton(
//             onPressed: () async {
//               await _save();
//               Navigator.pushReplacement(context,
//                   CupertinoPageRoute(builder: (BuildContext context) {
//                 return HomeScreen(userRepository: widget.userRepository);
//               }));
//             },
//             child: Text('Yes'),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _showNetworkError = false;

//   Future<bool> _checkConnection() async {
//     if (await DataConnectionChecker().hasConnection) {
//       setState(() {
//         _showNetworkError = false;
//       });
//       return true;
//     } else {
//       setState(() {
//         print('netwrok error');
//         _showNetworkError = true;
//       });
//       return false;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     // _sub = _controller.document.changes.listen((change) {
//     //   print('${change.source}: ${change.change}');
//     // });
//     // _controller = ZefyrController(NotusDocument.fromDelta(
//     //     Delta.fromJson(json.decode(widget.note.text) as List))); //1

//     _loadDocument().then((document) {
//       setState(() {
//         _controller = ZefyrController(document);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Widget body = (_controller == null)
//         ? Center(child: CircularProgressIndicator())
//         : ZefyrScaffold(
//             child: ZefyrEditor(
//               autofocus: false,
//               controller: _controller,
//               focusNode: _focusNode,
//               physics: BouncingScrollPhysics(),
//               imageDelegate: MyZefyrImageDelegate(),
//             ),
//           );
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Scaffold(
//         // resizeToAvoidBottomInset: false,
//         // resizeToAvoidBottomPadding: false,
//         key: _scaffoldkey,
//         backgroundColor: mainColor,
//         appBar: AppBar(
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.black),
//           backgroundColor: mainColor,
//           title: Text(
//             'Add your Note',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//               color: appBarIconColor,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.save),
//               onPressed: () => {
//                 _save(),
//               },
//             ),
//           ],
//         ),
//         body: body,
//       ),
//     );
//   }
// }

// class MyZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
//   final picker = ImagePicker();

//   @override
//   Widget buildImage(BuildContext context, String key) {
//     final file = File.fromUri(Uri.parse(key));
//     final image = FileImage(file);
//     return Image(image: image);
//   }

//   @override
//   ImageSource get cameraSource => ImageSource.camera;

//   @override
//   ImageSource get gallerySource => ImageSource.gallery;

//   @override
//   Future<String> pickImage(ImageSource source) async {
//     final file = await picker.getImage(source: source);
//     if (file == null) return null;
//     return file.path.toString();
//     //TODO: implement image storage in cloud storage
//   }
// }

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

class ZefyrNote extends StatefulWidget {
  // final Note note;

  final String contents;
  final String id;
  final String title;
  final DatabaseService databaseService;
  final UserRepository userRepository;
  const ZefyrNote(
      {Key key,
      this.id,
      this.contents,
      this.title,
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
  ZefyrController _controller;
  TextEditingController _titleController;
  // String initialText = "Title";

  _save() async {
    print('savvvvinggg....');
//
    // var contents = jsonEncode(_controller.document);
    // // For this example we save our document to a temporary file.
    // final file = File(Directory.systemTemp.path + "/quick_start.json");
    // // And show a snack bar on success.
    // file.writeAsString(contents);
//
    var datetime = new DateTime.now().toString();

    var dateParse = DateTime.parse(datetime);

    var date = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var contents = jsonEncode(_controller.document.toJson());
    Toast.show('Saving note.', context, duration: 100);
    if (await _checkConnection()) {
      await widget.databaseService.createZefyrUserData(
        contents: contents,
        title: _titleController.text,
        // date: DateTime.now().toString(),

        date: date.toString(),
      );
      Toast.show('Note saved sucessfully', context);
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return HomeScreen(userRepository: widget.userRepository);
      }));
    } else {
      Navigator.pop(context);
      Toast.show('Network Error', context);
    }
  }

  _update() async {
    print('updating.......');
    //TODO: update on mobile data
    var contents = jsonEncode(_controller.document.toJson());
    Toast.show('Updating note.', context, duration: 100);
    if (await _checkConnection()) {
      await widget.databaseService.updateZefyrUserData(
        contents: contents,
        title: _titleController.text,
        id: widget.id,
        date: DateTime.now().toString(),
      );
      Toast.show('Note updated sucessfully', context);
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return HomeScreen(userRepository: widget.userRepository);
      }));
    } else {
      Toast.show('Network Error', context);
    }
  }

  Future<NotusDocument> _loadDocument() async {
    // // final file = File(Directory.systemTemp.path + "/quick_start.json");
    // // if (await file.exists()) {
    // //   final contents = await file.readAsString();
    // //   return NotusDocument.fromJson(jsonDecode(contents));
    // // }
    var nomode = Provider.of<NoteModeProvider>(context, listen: false);

    if (nomode.notesmode == noteMode.editNote) {
      _titleController.text = widget.title;
      return NotusDocument.fromJson(jsonDecode(widget.contents));
    }
    _titleController.text = "Title";
    final Delta delta = Delta()..insert('Add your Note\n');
    return NotusDocument.fromDelta(delta);
  }

  FocusNode _focusNode;

  Future<bool> _onBackPressed() {
    if (_controller.document == null) Navigator.pop(context);
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
    // _controller = ZefyrController(NotusDocument.fromDelta(
    //     Delta.fromJson(json.decode(widget.note.text) as List))); //1
    _titleController = TextEditingController();
    _titleController.text = "Untitled Note";

    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var nomode = Provider.of<NoteModeProvider>(context, listen: false);

    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrTheme(
            data: ZefyrThemeData(
              toolbarTheme: ToolbarTheme.fallback(context).copyWith(
                color: Colors.white,
                iconColor: Colors.green,
              ),
            ),
            child: ZefyrScaffold(
              child: ZefyrEditor(
                // mode: null,

                keyboardAppearance: Brightness.light,
                autofocus: true,
                controller: _controller,
                focusNode: _focusNode,
                physics: BouncingScrollPhysics(),
                imageDelegate: MyZefyrImageDelegate(),
              ),
            ),
          );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: mainColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: mainColor,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0.2),
            child: TextFormField(
              // initialValue: _titleController.text,
              controller: _titleController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Untitled note',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // title: Text(
          //   'Add your Note',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w400,
          //     color: appBarIconColor,
          //   ),
          // ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => {
                if (_titleController.text.length == 0)
                  _titleController.text = "Untitled note",
                nomode.notesmode == noteMode.newNote ? _save() : _update(),
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
  // @override
  // Future<String> pickImage(ImageSource source) async {
  //   final image = await picker.getImage(source: source);
  //   if (image == null) return null;
  //   String filename = DateTime.now().millisecondsSinceEpoch.toString();
  //   final ref = FirebaseStorage.instance.ref().child(filename);
  //   StorageUploadTask uploadTask =
  //       ref.putFile(image, StorageMetadata(contentType: 'image/jpeg'));
  //   StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  //   return getImageUrl(storageTaskSnapshot);
  // }
}
