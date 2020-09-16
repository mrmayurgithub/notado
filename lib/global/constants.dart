import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

double screenHeight = 1001.0694778740428;
double screenWidth = 462.03206671109666;
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
