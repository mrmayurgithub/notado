import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/ui/screens/handwritten_note_screen/paint.dart';
import 'package:toast/toast.dart';

class DrawModel {
  List<Offset> points = <Offset>[];
  Color brushColor = Colors.blue;
  double strokeWidth = 10.0;
}

List<Offset> _points = [];
List<Offset> _revPoints = [];
List<Offset> _deletedPoints = [];
List<DrawModel> drawModelPoints = [];
double brushWidth = 4.0;
Color brushColor = Colors.black;
int count = 0;

class DrawScreen extends StatefulWidget {
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

  Future<bool> _onBackButtonPressed() {
    return showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text('Do you want to save it ?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              //TODO: implement save handwriting
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  _checkPressed() {
    return showDialog(
      context: context,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AlertDialog(
          title: Text(
            'Enter the title',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline5.color,
            ),
          ),
          content: Form(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.headline5.color,
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO: implement it
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                actionsIconTheme:
                    Theme.of(context).iconTheme.copyWith(color: Colors.black),
                elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 17,
                  ),
                  onPressed: () {
                    _points.clear();
                    Navigator.of(context).pop();
                  },
                ),
                title: Text('Write'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.undo,
                      size: 17,
                    ),
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
                            for (int i = 0; i < count; i++) {
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
                        Scaffold.of(context).hideCurrentSnackBar();
                        Toast.show('You haven\'t drawn anything yet', context);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.redo,
                      size: 17,
                    ),
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
                            if (c == 1) {
                              for (int i = 0; i < _deletedPoints.length; i++) {
                                _points.add(_deletedPoints[i]);
                              }
                            } else {
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
                              _deletedPoints.removeRange(
                                  _deletedPoints.length - i - 1,
                                  _deletedPoints.length - 1);
                            }
                            _revPoints.clear();
                          },
                        );
                        logger.v(_points.toList().toString());
                      } catch (e) {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Toast.show(e.toString(), context);
                      }
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.check),
                  //   onPressed: () async {
                  //     singledrawModel.points = _points;
                  //     singledrawModel.brushColor = brushColor;
                  //     singledrawModel.strokeWidth = brushWidth;
                  //     drawModelPoints.add(singledrawModel);
                  //     print(singledrawModel.points.toString());
                  //     _points.clear();
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.done,
                      size: 17,
                    ),
                    onPressed: () {
                      singledrawModel.points = _points;
                      singledrawModel.brushColor = brushColor;
                      singledrawModel.strokeWidth = brushWidth;
                      drawModelPoints.add(singledrawModel);
                      print(singledrawModel.points.toString());
                      // _points.clear();
                      _checkPressed();
                    },
                  ),
                ],
              ),
              body: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Container(
                        child: GestureDetector(
                          onPanUpdate: (DragUpdateDetails details) {
                            setState(() {
                              RenderBox object = context.findRenderObject();
                              Offset _localPosition =
                                  object.globalToLocal(details.globalPosition);

                              _points = List.from(_points)..add(_localPosition);
                            });
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
                    );
                  },
                ),
              ),
              floatingActionButton: Speeddial(
                speedDialtext: 18 / 1001.0694778740428,
                height: MediaQuery.of(context).size.height,
              ),
            );
          },
        ),
      ),
    );
  }
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
      backgroundColor: Theme.of(context).textTheme.bodyText2.color,
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

speedialTextSize(double speedDialtext, double height) {}
