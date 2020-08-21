import 'dart:io';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notado/models/draw_screen_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/screens/draw/draw_screen.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'dart:math' as math;

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  File _image;
  TextEditingController titleController;
  TextEditingController noteController;
  bool isItalic = false;
  bool isBold = false;
  bool isTextHigh = false;
  bool isTextUnderlined = false;
  bool underlinePressed = false;
  bool strikeThroughPressed = false;
  bool boldPressed = false;
  bool italicPressed = false;
  bool textsizePressed = false;
  final h = 1001.0694778740428;
  final w = 462.03206671109666;
  var choiceSize = 20 / 1001.0694778740428;
  bool addImageChoice = false;
  AnimationController _controller;
  final bottomBarIconSize = 30.0;
  final picker = ImagePicker();
  ColorSwatch _mainColor = Colors.blue;
  Color _shadeColor = Colors.blue[800];
  ColorSwatch _tempMainColor;
  Color oldColor;
  Color mainColor = Colors.white;
  Color permanentColor;
  TextAlign align = TextAlign.left;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  oldColor = mainColor;
                  mainColor = permanentColor;
                });
                // setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  // void _openColorPicker() async {
  //   _openDialog(
  //     "Color picker",
  //     MaterialColorPicker(
  //       selectedColor: _shadeColor,
  //       onColorChange: (color) => setState(() => _tempShadeColor = color),
  //       onMainColorChange: (color) => setState(() => mainColor = color),
  //       onBack: () => print("Back button pressed"),
  //     ),
  //   );
  // }

  void _openColorPicker() async {
    _openDialog(
      "Choose a color",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => permanentColor = color),
        // onBack: () => print("Back button pressed"),
      ),
    );
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

  static const List<IconData> icons = const [
    Icons.insert_photo,
    Icons.mic,
    Icons.brush,
  ];

  // static List<FloatingActionButton> floatingActionButtons = [
  //   FloatingActionButton(
  //     heroTag: null,
  //     tooltip: 'Draw',
  //     backgroundColor: Colors.green,
  //     mini: true,
  //     onPressed: () => {},
  //     child: Icon(Icons.brush),
  //   ),
  //   FloatingActionButton(
  //     heroTag: null,
  //     mini: true,
  //     backgroundColor: Colors.green,
  //     tooltip: 'Insert Image',
  //     onPressed: () => {},
  //     child: Icon(Icons.add_a_photo),
  //   ),
  //   FloatingActionButton(
  //     heroTag: null,
  //     mini: true,
  //     backgroundColor: Colors.green,
  //     tooltip: 'Insert voice',
  //     onPressed: () => {},
  //     child: Icon(Icons.mic),
  //   ),
  // ];
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
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
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
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
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
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        // shape: AutomaticNotchedShape(),
        elevation: 10,
        color: mainColor,
        notchMargin: 8,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.text_format,
                  size: 40,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.showBottomSheet(
                    (context) => Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        color: mainColor,
                      ),
                      height: 200,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(11),
                            child: Text(
                              'Select Style',
                              style: TextStyle(
                                letterSpacing: 0.7,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.format_bold,
                                    color: boldPressed
                                        ? Colors.black
                                        : Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                  onPressed: () => setState(
                                    () {
                                      isBold = !isBold;
                                      if (isBold) {
                                        boldPressed = true;
                                      } else {
                                        boldPressed = false;
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () => setState(
                                    () {
                                      isItalic = !isItalic;
                                      if (isItalic)
                                        italicPressed = true;
                                      else
                                        italicPressed = false;
                                      Navigator.pop(context);
                                    },
                                  ),
                                  // _scaffoldKey.currentState.setState(() {
                                  //   isItalic = !isItalic;
                                  //   if (isItalic)
                                  //     italicPressed = true;
                                  //   else
                                  //     italicPressed = false;
                                  //   Navigator.pop(context);
                                  // }),
                                  icon: Icon(
                                    Icons.format_italic,
                                    color: italicPressed
                                        ? Colors.black
                                        : Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.format_underlined,
                                    color: underlinePressed
                                        ? Colors.black
                                        : Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                  onPressed: () => setState(
                                    () {
                                      isTextUnderlined = !isTextUnderlined;
                                      if (isTextUnderlined)
                                        underlinePressed = true;
                                      else
                                        underlinePressed = false;
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.format_size,
                                    color: textsizePressed
                                        ? Colors.black
                                        : Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                  onPressed: () => setState(
                                    () {
                                      isTextHigh = !isTextHigh;
                                      if (isTextHigh)
                                        textsizePressed = true;
                                      else
                                        textsizePressed = false;
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () => setState(
                                    () {
                                      if (align == TextAlign.center) {
                                        align = TextAlign.left;
                                      } else {
                                        align = TextAlign.center;
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.format_align_center,
                                    color: Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () => setState(
                                    () {
                                      if (align == TextAlign.right) {
                                        align = TextAlign.left;
                                      } else {
                                        align = TextAlign.right;
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.format_align_right,
                                    color: Colors.black45,
                                    size: bottomBarIconSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // color: Theme.of(context)
                              //     .bottomSheetTheme
                              //     .backgroundColor,
                              color: mainColor,
                              // boxShadow: [
                              //   BoxShadow(color: Colors.grey[100]),
                              // ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_drop_down, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              IconButton(icon: Icon(Icons.check_box), onPressed: null),
              IconButton(icon: Icon(Icons.strikethrough_s), onPressed: null),
              IconButton(
                  icon: Icon(Icons.format_list_bulleted), onPressed: null),
              IconButton(
                  icon: Icon(Icons.format_list_numbered), onPressed: null),
              IconButton(
                icon: Icon(Icons.format_color_fill),
                onPressed: () => _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: AlertDialog(
                      content: Container(
                        height: 300,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 5,
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.orange,
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.pink,
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.purple,
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.deepPurple,
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // _openColorPicker()
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        //TODO: implement the bottomSheet pop thing
        // onPress: () => {
        //   Navigator.pop(context),
        // },
        marginBottom: 30,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        curve: Curves.bounceInOut,
        elevation: 10.0,
        // backgroundColor: Colors.transparent,
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
        foregroundColor:
            mainColor == Colors.white ? Colors.green : Colors.white,
        backgroundColor: mainColor,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(FontAwesomeIcons.adobe),
            // label: 'Draw',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () => Navigator.push(context, _createRoute()),
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,

            child: Icon(Icons.add_a_photo),
            // label: 'Insert Image',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () {
              _showDialogBox(context, choiceSize * height);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,

            child: Icon(Icons.mic),
            // label: 'Add voice note',
            labelStyle: speedialTextSize(speedDialtext, height),
            onTap: () => print('SECOND CHILD'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Builder(
        builder: (context) => Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                height: height,
                color: mainColor,
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
                          color: mainColor,
                          elevation: 0.0,
                          shadowColor: mainColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PadH * width * 3,
                              vertical: PadV * height * 3,
                            ),

                            // TODO: Maybe use RawKeyboardListner
                            child: TextFormField(
                              textAlign: align,
                              // centerAlign == true
                              //     ? TextAlign.center
                              //     : rightAlign == true
                              //         ? TextAlign.right
                              //         : TextAlign.left,
                              autofocus: false,
                              maxLines: 4,
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
                                letterSpacing: 0.9,
                                fontStyle:
                                    isItalic == false ? null : FontStyle.italic,
                                fontWeight: isBold == false
                                    ? FontWeight.w300
                                    : FontWeight.w600,
                                decoration: underlinePressed
                                    ? TextDecoration.underline
                                    : null,
                                //TODO: implement lineThrough
                                // decoration: TextDecoration.combine([
                                //   underlinePressed
                                //       ? TextDecoration.underline
                                //       : null,
                                //   strikeThroughPressed
                                //       ? TextDecoration.lineThrough
                                //       : null,
                                // ]),
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
                                  decoration: underlinePressed
                                      ? TextDecoration.underline
                                      : null,
                                  // decoration: TextDecoration.combine(
                                  //   [
                                  //     underlinePressed
                                  //         ? TextDecoration.underline
                                  //         : null,
                                  //     strikeThroughPressed
                                  //         ? TextDecoration.lineThrough
                                  //         : null,
                                  //   ],
                                  // ),
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
