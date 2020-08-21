import 'package:flutter/material.dart';
import 'package:notado/models/draw_screen_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/addnote/addnote_screen.dart';
import 'package:notado/user_repository/user_Repository.dart';

List<Offset> _points = [];
List<Offset> _revPoints = [];
List<Offset> _deletedPoints = [];
List<DrawModel> drawModelPoints = <DrawModel>[];

double brushWidth = 4.0;
Color brushColor = Colors.blue;
int count = 0;

class DrawScreen extends StatefulWidget {
  final UserRepository userRepository;
  // final List<DrawModel> drawModel;

  const DrawScreen({Key key, @required this.userRepository}) : super(key: key);
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  DrawModel singledrawModel;

  @override
  void initState() {
    singledrawModel = DrawModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int z = 0;

    final h = 1001.0694778740428;
    var formKey = GlobalKey<FormState>();
    final cancelCheck = 5 / h;
    final appBarHeight = 60 / h;
    final w = 462.03206671109666;
    final speedDialtext = 18 / h;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    final arrowBacksize = 20 / h;
    //TODO: Maybe delete below line
    BuildContext _context = context;
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: topAppBar(arrowBacksize, height, context, z),
          body: Scaffold(
            body: Builder(
              builder: (BuildContext context) => SafeArea(
                child: Container(
                  child: GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(
                        () {
                          RenderBox object = context.findRenderObject();
                          Offset _localPosition =
                              object.globalToLocal(details.globalPosition);
                          _points = List.from(_points)..add(_localPosition);
                        },
                      );
                    },
                    onPanEnd: (DragEndDetails details) => {
                      _deletedPoints.clear(),
                      _points.add(null),
                      // _listPoints.add(_points),
                      // _listPoints = List.from(_listPoints)..add(_points),
                    },
                    child: CustomPaint(
                      painter: Draw(points: _points),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton:
              Speeddial(speedDialtext: speedDialtext, height: height),
        ),
      ),
    );
  }

  AppBar topAppBar(
      double arrowBacksize, double height, BuildContext context, int z) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: arrowBacksize * height),
        onPressed: () => {
          _points.clear(),
          //_listPoints.removeAt(_listPoints.length - 1),
          Navigator.pop(context),
        },
      ),
      title: drawText(),
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.undo, size: 17),
          onPressed: () {
            try {
              int c = 0;
              setState(() {
                for (int k = 0; k < _points.length; k++) {
                  if (_points[k] == null) {
                    c++;
                    if (c == 2) break;
                  }
                }
                if (c == 1) {
                  for (int i = 0; i < _points.length; i++) {
                    _deletedPoints.add(_points[i]);
                  }
                  _points.clear();
                } else {
                  _revPoints = _points.reversed.toList();
                  int i, count = 0;
                  for (i = 0; i < _revPoints.length; i++) {
                    if (_revPoints[i] == null) {
                      count++;
                      if (count == 2) break;
                    }
                  }
                  for (int k = _points.length - i - 1;
                      k < _points.length;
                      k++) {
                    _deletedPoints.add(_points[k]);
                  }

                  _points.removeRange(
                      _points.length - i - 1, _points.length - 1);
                }
              });
            } catch (e) {
              //TODO: Check
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString(),
                    //'You haven\'t drawn anything yet',
                    style: TextStyle(),
                  ),
                ),
              );
            }
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.redo, size: 17),
          onPressed: () {
            try {
              setState(
                () {
                  int c = 0;
                  for (int k = 0; k < _points.length; k++) {
                    if (_points[k] == null) {
                      c++;
                      if (c == 2) break;
                    }
                  }
                  if (c == 1)
                    for (int i = 0; i < _deletedPoints.length; i++) {
                      _points.add(_deletedPoints[i]);
                    }
                  else {
                    int count = 0, i;
                    _revPoints = _deletedPoints.reversed.toList();
                    for (i = 0; i < _revPoints.length; i++) {
                      if (_revPoints[i] == null) {
                        count++;
                        if (count == 2) break;
                      }
                    }
                    for (int j = _deletedPoints.length - i;
                        j < _deletedPoints.length;
                        j++) {
                      _points.add(_deletedPoints[j]);
                    }

                    _deletedPoints.removeRange(_deletedPoints.length - i - 1,
                        _deletedPoints.length - 1);
                  }
                  _revPoints.clear();
                },
              );
              print(_points.toList());
            } catch (e) {
              if (z <= 1) {
                //TODO: Check
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              } else
                Scaffold.of(context).setState(() {});
              z++;
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.black,
          ),
          onPressed: () async {
            singledrawModel.points = _points;
            singledrawModel.brushColor = brushColor;
            singledrawModel.strokeWidth = brushWidth;
            drawModelPoints.add(singledrawModel);

            print(singledrawModel.points.toString());
            _points.clear();

            //TODO: implement add drawModel to notes Model
            // Navigator.pop(context);

/******************************************************************* */
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AddNote(
                  userRepository: widget.userRepository,
                  drawModel: drawModelPoints,
                );
              }),
            );
            /************************************************************* */
            // if (formKey.currentState.validate()) {
            //   formKey.currentState.save();
            // note.save();}

//TODO Save drawing points to firebase

            // String userId = (await FirebaseAuth.instance.currentUser()).uid;
            // try {
            //   await DatabaseService(uid: userId).createUserData(
            //     date: null,
            //     title: null,
            //     notes: null,
            //     color: null,
            //     image: null,
            //     isBold: null,
            //     isItalic: null,
            //     isTextHigh: null,
            //     drawPoints: _points,
            //   );
            //   _points.clear();
            //   Navigator.pop(context);
            // } catch (e) {
            //   Scaffold.of(context)
            //       .showSnackBar(SnackBar(content: Text(e.toString())));
            // }
          },
        ),
      ],
    );
  }

  RichText drawText() {
    return RichText(
      text: TextSpan(
        text: 'D',
        style: TextStyle(
          fontSize: 25,
          color: Colors.deepOrange,
          //fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'R',
            style: TextStyle(
              fontSize: 25,
              color: Colors.green,
            ),
          ),
          TextSpan(
            text: 'A',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: 'W',
            style: TextStyle(
              fontSize: 25,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class Draw extends CustomPainter {
  List<Offset> points;
  // List<List<Offset>> points;
  Draw({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushWidth;

    // for (int i = 0; i < points.length; i++)
    //   for (int j = 0; j < points[i].length - 1; j++)
    //     if (points[i][j] != null && points[i][j + 1] != null) {
    //       canvas.drawLine(points[i][j], points[i][j], paint);
    //     }

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Draw oldDelegate) => oldDelegate.points != points;
}

class Speeddial extends StatelessWidget {
  const Speeddial({
    Key key,
    @required this.speedDialtext,
    @required this.height,
  }) : super(key: key);

  final double speedDialtext;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.edit),
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          backgroundColor: Colors.white,
          child: Icon(Icons.clear, color: Colors.black),
          label: 'Clear All',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () {
            // ignore: invalid_use_of_protected_member
            Scaffold.of(context).setState(() {
              _points.clear();
            });
          },
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          child:
              Icon(FontAwesomeIcons.paintBrush, color: Colors.black, size: 15),
          label: 'Brush Size 10',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () => brushWidth = 4,
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          child:
              Icon(FontAwesomeIcons.paintBrush, color: Colors.black, size: 20),
          label: 'Brush Size 25',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () => brushWidth = 25,
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          child: Icon(FontAwesomeIcons.paintBrush, color: Colors.red, size: 20),
          label: 'Red',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () => brushColor = Colors.red,
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          child:
              Icon(FontAwesomeIcons.paintBrush, color: Colors.green, size: 20),
          label: 'Green',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () => brushColor = Colors.green,
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          child:
              Icon(FontAwesomeIcons.paintBrush, color: Colors.black, size: 20),
          label: 'Black',
          labelStyle: speedialTextSize(speedDialtext, height),
          onTap: () => brushColor = Colors.black,
        ),
      ],
    );
  }
}

class DrawText extends StatelessWidget {
  const DrawText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'D',
        style: TextStyle(
          fontSize: 25,
          color: Colors.deepOrange,
          //fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'R',
            style: TextStyle(
              fontSize: 25,
              color: Colors.green,
            ),
          ),
          TextSpan(
            text: 'A',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: 'W',
            style: TextStyle(
              fontSize: 25,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

speedialTextSize(double speedDialtext, double height) {}

// class DrawScreen extends StatefulWidget {
//   final UserRepository userRepository;
//   // final List<DrawModel> drawModel;

//   const DrawScreen({Key key, @required this.userRepository}) : super(key: key);
//   @override
//   _DrawScreenState createState() => _DrawScreenState();
// }

// class _DrawScreenState extends State<DrawScreen> {
//   DrawModel singledrawModel;

//   @override
//   void initState() {
//     singledrawModel = DrawModel();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = 1001.0694778740428;
//     var formKey = GlobalKey<FormState>();
//     final cancelCheck = 5 / h;
//     final appBarHeight = 60 / h;
//     final w = 462.03206671109666;
//     final speedDialtext = 18 / h;
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     Size size = MediaQuery.of(context).size;
//     final arrowBacksize = 20 / h;
//     //TODO: Maybe delete below line
//     BuildContext _context = context;
//     return Scaffold(
//       body: Builder(
//         builder: (BuildContext context) => SafeArea(
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 child: GestureDetector(
//                   onPanUpdate: (DragUpdateDetails details) {
//                     setState(
//                       () {
//                         RenderBox object = context.findRenderObject();
//                         Offset _localPosition =
//                             object.globalToLocal(details.globalPosition);
//                         _points = List.from(_points)..add(_localPosition);
//                       },
//                     );
//                   },
//                   onPanEnd: (DragEndDetails details) => {
//                     _deletedPoints.clear(),
//                     _points.add(null),
//                     // _listPoints.add(_points),
//                     // _listPoints = List.from(_listPoints)..add(_points),
//                   },
//                   child: CustomPaint(
//                     painter: Draw(points: _points),
//                     size: Size.infinite,
//                   ),
//                 ),
//               ),
//               TopAppBar(
//                 appBarHeight: appBarHeight,
//                 height: height,
//                 arrowBacksize: arrowBacksize,
//                 singledrawModel: singledrawModel,
//                 userRepository: widget.userRepository,
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton:
//           Speeddial(speedDialtext: speedDialtext, height: height),
//     );
//   }
// }

// class TopAppBar extends StatelessWidget {
//   const TopAppBar({
//     Key key,
//     @required this.appBarHeight,
//     @required this.height,
//     @required this.arrowBacksize,
//     @required this.singledrawModel,
//     @required this.userRepository,
//   }) : super(key: key);

//   final double appBarHeight;
//   final double height;
//   final double arrowBacksize;
//   final DrawModel singledrawModel;
//   final UserRepository userRepository;
//   @override
//   Widget build(BuildContext context) {
//     int z = 0;
//     return Container(
//       height: appBarHeight * height,
//       width: double.infinity,
//       // color: Colors.grey,
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_back_ios, size: arrowBacksize * height),
//             onPressed: () => {
//               _points.clear(),
//               //_listPoints.removeAt(_listPoints.length - 1),
//               Navigator.pop(context),
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.all(5),
//             child: DrawText(),
//           ),
//           SizedBox(width: 168),
//           IconButton(
//             icon: Icon(FontAwesomeIcons.undo, size: 17),
//             onPressed: () {
//               try {
//                 int c = 0;
//                 Scaffold.of(context).setState(() {
//                   for (int k = 0; k < _points.length; k++) {
//                     if (_points[k] == null) {
//                       c++;
//                       if (c == 2) break;
//                     }
//                   }
//                   if (c == 1)
//                     _points.clear();
//                   else {
//                     _revPoints = _points.reversed.toList();
//                     int i, count = 0;
//                     for (i = 0; i < _revPoints.length; i++) {
//                       if (_revPoints[i] == null) {
//                         count++;
//                         if (count == 2) break;
//                       }
//                     }
//                     for (int k = _points.length - i - 1;
//                         k < _points.length;
//                         k++) {
//                       _deletedPoints.add(_points[k]);
//                     }

//                     _points.removeRange(
//                         _points.length - i - 1, _points.length - 1);
//                   }
//                 });
//               } catch (e) {
//                 Scaffold.of(context).hideCurrentSnackBar();
//                 Scaffold.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       e.toString(),
//                       //'You haven\'t drawn anything yet',
//                       style: TextStyle(),
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(FontAwesomeIcons.redo, size: 17),
//             onPressed: () {
//               try {
//                 Scaffold.of(context).setState(
//                   () {
//                     int c = 0;
//                     for (int k = 0; k < _points.length; k++) {
//                       if (_points[k] == null) {
//                         c++;
//                         if (c == 2) break;
//                       }
//                     }
//                     if (c == 1)
//                       for (int i = 0; i < _deletedPoints.length; i++) {
//                         _points.add(_deletedPoints[i]);
//                       }
//                     else {
//                       int count = 0, i;
//                       _revPoints = _deletedPoints.reversed.toList();
//                       for (i = 0; i < _revPoints.length; i++) {
//                         if (_revPoints[i] == null) {
//                           count++;
//                         }
//                         if (count == 2) break;
//                       }
//                       for (int j = _deletedPoints.length - i - 1;
//                           j < _deletedPoints.length;
//                           j++) {
//                         _points.add(_deletedPoints[j]);
//                       }

//                       _deletedPoints.removeRange(_deletedPoints.length - i - 1,
//                           _deletedPoints.length - 1);
//                     }
//                     _revPoints.clear();
//                   },
//                 );
//                 print(_points.toList());
//               } catch (e) {
//                 if (z <= 1) {
//                   Scaffold.of(context).hideCurrentSnackBar();
//                   Scaffold.of(context).showSnackBar(
//                     SnackBar(
//                       duration: Duration(seconds: 2),
//                       content: Text(
//                         e.toString(),
//                       ),
//                     ),
//                   );
//                 } else
//                   Scaffold.of(context).setState(() {});
//                 z++;
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.check,
//               color: Colors.black,
//             ),
//             onPressed: () async {
//               singledrawModel.points = _points;
//               singledrawModel.brushColor = brushColor;
//               singledrawModel.strokeWidth = brushWidth;
//               drawModelPoints.add(singledrawModel);

//               print(singledrawModel.points.toString());
//               _points.clear();

//               //TODO: implement add drawModel to notes Model
//               // Navigator.pop(context);

// /******************************************************************* */
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (BuildContext context) {
//                   return AddNote(
//                     userRepository: userRepository,
//                     drawModel: drawModelPoints,
//                   );
//                 }),
//               );
//               /************************************************************* */
//               // if (formKey.currentState.validate()) {
//               //   formKey.currentState.save();
//               // note.save();}

// //TODO Save drawing points to firebase

//               // String userId = (await FirebaseAuth.instance.currentUser()).uid;
//               // try {
//               //   await DatabaseService(uid: userId).createUserData(
//               //     date: null,
//               //     title: null,
//               //     notes: null,
//               //     color: null,
//               //     image: null,
//               //     isBold: null,
//               //     isItalic: null,
//               //     isTextHigh: null,
//               //     drawPoints: _points,
//               //   );
//               //   _points.clear();
//               //   Navigator.pop(context);
//               // } catch (e) {
//               //   Scaffold.of(context)
//               //       .showSnackBar(SnackBar(content: Text(e.toString())));
//               // }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
