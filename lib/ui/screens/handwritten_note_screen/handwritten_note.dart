import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notado/global/constants.dart';
import 'package:toast/toast.dart';

List<Offset> _points = [];
List<Offset> _revPoints = [];
List<Offset> _deletedPoints = [];
List<DrawModel> _drawModelPoints = [];
double brushWidth = 4.0;
Color brushColor = Colors.black;
int count = 0;

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
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
                  icon: Icon(FontAwesomeIcons.undo),
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
                    color: Colors.black,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
