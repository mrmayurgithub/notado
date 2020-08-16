import 'dart:io';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:notado/models/draw_screen_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/screens/draw/draw_screen.dart';
import 'package:notado/user_repository/user_Repository.dart';

List<File> images = [];

class AddNote extends StatefulWidget {
  final UserRepository userRepository;
  final List<DrawModel> drawModel;

  const AddNote({Key key, @required this.userRepository, this.drawModel})
      : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  File _image;
  TextEditingController titleController;
  TextEditingController noteController;
  bool isItalic = false;
  bool isBold = false;
  bool isTextHigh = false;
  bool isTextUnderlined = false;
  bool underlinePressed = false;
  bool boldPressed = false;
  bool italicPressed = false;
  bool textsizePressed = false;
  final h = 1001.0694778740428;
  final w = 462.03206671109666;
  var choiceSize = 20 / 1001.0694778740428;
  bool addImageChoice = false;
  AnimationController _controller;
  final bottomBarIconSize = 30.0;
  bool alignActive = true;
  bool leftAlign = true;
  bool centerAlign = false;
  bool rightAlign = false;
  TextAlign align = TextAlign.left;

  // List<DrawModel> drawModel = [];
  final picker = ImagePicker();

  void changeColor(Color color) {
    ///TODO: implement color change of the screen
  }

  // ignore: unused_element
  _openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      images.add(_image);
    });
  }

  // ignore: unused_element
  _openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      images.add(_image);
    });
  }

  Future<void> _showDialogBox(BuildContext context, double choiceTextSize) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          title: Text(
            'Make a choice',
            style: TextStyle(fontSize: choiceTextSize),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {_openGallery()},
                  child: Text('Gallery'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  //   child: Divider(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () => {_openCamera()},
                  child: Text('Camera'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // drawModel = <DrawModel>[];
    // initializing the animation contoller variable _controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    super.initState();
  }

  @override
  void dispose() {
    // Disposing _controller when not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  InlineSpan finishText() {}

  @override
  Widget build(BuildContext context) {
    final speedDialtext = 18 / h;
    final pageTitleSize = 35 / h;
    final titlePadV = 10 / h;
    final titlePadH = 10 / w;
    final PadV = 4 / h;
    final PadH = 4 / w;
    final noImagebox = 1 / h;
    final cancelCheck = 5 / h;
    final imageContainerPadV = 4 / h;
    final imageContainerPadH = 4 / w;
    final topIconsPad = 84 / w;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final arrowBacksize = 25 / h;
    final undoRedoSize = 30 / h;
    final appBarIconColor = Colors.black;
    final ImageColumnPad = 4.5 / w;
    String initialText = '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add your Note',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: appBarIconColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: appBarIconColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: appBarIconColor),
            onPressed: () => {
              setState(() {}),
            },
          ),
          IconButton(
            icon: Icon(Icons.redo, color: appBarIconColor),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.check, color: appBarIconColor),
            onPressed: () => {
              //TODO: apply addNote function
              if (formKey.currentState.validate()) {}
            },
            // onPressed: () => {
            //   if (formKey.currentState.validate())
            //     {formKey.currentState.save()},
            //   note.save()
            // },
          ),
        ],
      ),
      bottomNavigationBar: buildBottomAppBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(onPressed: () {}),
      floatingActionButton: SpeedDial(
        elevation: 0.0,
        overlayColor: Colors.transparent,
        overlayOpacity: 0.0,
        shape: CircleBorder(
          side: BorderSide.none,
        ),
        backgroundColor: Colors.purple,
        // child: ShaderMask(
        //   shaderCallback: (Rect bounds) {
        //     return LinearGradient(
        //       colors: <Color>[
        //         Colors.red,
        //         Colors.blue,
        //         //Colors.yellow,
        //         Colors.deepOrange,
        //       ],
        //       // tileMode: TileMode.repeated,
        //     ).createShader(bounds);
        //   },
        //   child: Icon(Icons.edit),
        // ),
        animatedIcon: AnimatedIcons.event_add,
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.adobe),
            label: 'Draw',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () => Navigator.push(context, _createRoute()),
          ),
          SpeedDialChild(
            child: Icon(Icons.add_a_photo),
            label: 'Insert Image',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () {
              _showDialogBox(context, choiceSize * height);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.mic),
            label: 'Add voice note',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () => print('SECOND CHILD'),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                height: height,
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        // widget.drawModel != null
                        //     ? null
                        //     //TODO: Implement it
                        //     // Transform.scale(
                        //     //     scale: 0.5,
                        //     //     child: Scaffold(
                        //     //       body: Container(
                        //     //         child: CustomPaint(
                        //     //           painter: Draw(
                        //     //               points: widget
                        //     //                   .drawModel[
                        //     //                       widget.drawModel.length - 1]
                        //     //                   .points),
                        //     //         ),
                        //     //       ),
                        //     //     ),
                        //     //   )
                        //     : SizedBox(height: 10),
                        images.length != 0
                            // List view for images
                            ? Column(
                                children: <Widget>[
                                  for (int i = 0; i < images.length; i++)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ImageColumnPad * width),
                                      child: Dismissible(
                                        key: ObjectKey(images[i]),
                                        onDismissed: (direction) {
                                          var item = images.elementAt(i);
                                          deleteItem(i);
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              shape: RoundedRectangleBorder(),
                                              content: Text("Item deleted",
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              action: SnackBarAction(
                                                label: "UNDO",
                                                onPressed: () {
                                                  undoDeletion(i, item);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: GestureDetector(
                                          onTap: () => {
                                            //TODO: Implement delete function here
                                          },
                                          child: Center(
                                            child: Image.file(
                                              images[i],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : SizedBox(height: 2),
                        Card(
                          elevation: 0.0,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PadH * width * 3,
                              vertical: PadV * height * 3,
                            ),

                            // TODO: Maybe use RawKeyboardListner
                            child: TextFormField(
                              textAlign: align,
                              autofocus: false,
                              maxLines: 10,
                              scrollPhysics: BouncingScrollPhysics(),
                              controller: noteController,
                              enableInteractiveSelection: true,
                              initialValue: initialText,
                              textCapitalization: TextCapitalization.sentences,
                              onSaved: (s) => {
                                //TODO: implement notes.notes = s, noteController.text
                              },
                              validator: (s) =>
                                  s.length > 0 ? null : 'Note can\'t be empty',
                              // onChanged: (value) => {
                              //   initialText = noteController.text,
                              //   print(noteController.text),
                              // },

                              style: TextStyle(
                                fontSize: isTextHigh == false ? 17 : 20,
                                letterSpacing: 0.7,
                                fontStyle:
                                    isItalic == false ? null : FontStyle.italic,
                                fontWeight: isBold == false
                                    ? FontWeight.w300
                                    : FontWeight.bold,
                                decoration: underlinePressed
                                    ? TextDecoration.underline
                                    : null,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Write Note',
                                hintStyle: TextStyle(
                                  letterSpacing: 0.7,
                                  fontWeight: isBold == false
                                      ? FontWeight.w300
                                      : FontWeight.bold,
                                  fontStyle: isItalic == false
                                      ? null
                                      : FontStyle.italic,
                                  color: addNoteColor,
                                  fontSize: isTextHigh == false ? 15 : 19,
                                  // decoration: underlinePressed
                                  //     ? TextDecoration.underline
                                  //     : null,
                                  decoration: underlinePressed
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      elevation: 10.0,
      // color: Colors.transparent,
      shape: CircularNotchedRectangle(),
      notchMargin: -10,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => setState(
                () {
                  isItalic = !isItalic;
                  if (isItalic)
                    italicPressed = true;
                  else
                    italicPressed = false;
                },
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.format_italic,
                  color: italicPressed ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                () {
                  isBold = !isBold;
                  if (isBold) {
                    boldPressed = true;
                  } else {
                    boldPressed = false;
                  }
                },
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.format_bold,
                  color: boldPressed ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                () {
                  isTextHigh = !isTextHigh;
                  if (isTextHigh)
                    textsizePressed = true;
                  else
                    textsizePressed = false;
                },
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.format_size,
                  color: textsizePressed ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                () {
                  isTextUnderlined = !isTextUnderlined;
                  if (isTextUnderlined)
                    underlinePressed = true;
                  else
                    underlinePressed = false;
                },
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.format_underlined,
                  color: underlinePressed ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: IconButton(
                onPressed: () => setState(
                  () {
                    if (alignActive == false) {
                      alignActive = true;
                      centerAlign = false;
                      rightAlign = false;
                      leftAlign = true;
                      align = TextAlign.left;
                    } else {
                      alignActive = false;
                      align = TextAlign.left;
                    }
                  },
                ),
                icon: Icon(
                  Icons.format_align_left,
                  color: leftAlign ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: IconButton(
                onPressed: () => setState(
                  () {
                    if (alignActive == false) {
                      alignActive = true;
                      centerAlign = true;
                      rightAlign = false;
                      leftAlign = false;
                      align = TextAlign.center;
                    } else {
                      alignActive = false;
                      align = TextAlign.left;
                      centerAlign = false;
                    }
                  },
                ),
                icon: Icon(
                  Icons.format_align_center,
                  color: centerAlign ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: IconButton(
                onPressed: () => setState(
                  () {
                    if (alignActive == false) {
                      alignActive = true;
                      centerAlign = false;
                      rightAlign = true;
                      leftAlign = false;
                      align = TextAlign.right;
                    } else {
                      alignActive = false;
                      align = TextAlign.left;
                      rightAlign = false;
                    }
                  },
                ),
                icon: Icon(
                  Icons.format_align_right,
                  color: rightAlign ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: IconButton(
                onPressed: () => setState(
                  () {},
                ),
                icon: Icon(
                  Icons.check_box,
                  color: rightAlign ? Colors.black : Colors.black45,
                  size: bottomBarIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 440),
      pageBuilder: (context, animation, secondaryAnimation) =>
          DrawScreen(userRepository: widget.userRepository),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 1);
        var end = Offset.zero;
        var curve = Curves.easeInOutQuad;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
        //return FadeTransition(opacity: animation.drive(tween), child: child);
      },
    );
  }

  TextStyle speedialTextSize(double speedDialtext, double height) {
    return TextStyle(fontSize: speedDialtext * height, color: Colors.black);
  }

  void deleteItem(index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void undoDeletion(index, item) {
    setState(() {
      images.insert(index, item);
    });
  }
}

class Draw extends CustomPainter {
  List<Offset> points;
  // List<List<Offset>> points;
  Draw({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Draw oldDelegate) => oldDelegate.points != points;
}
