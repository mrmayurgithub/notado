import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

// double screenHeight = 1001.0694778740428;
// double screenWidth = 462.03206671109666;
final buttonBorderRadius = BorderRadius.circular(10);
Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    errorMethodCount: 3,
    lineLength: 50,
    methodCount: 0,
    printEmojis: true,
    printTime: false,
  ),
);

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
