import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showProgress(BuildContext context) {
  showDialog(
    barrierColor: Colors.black,
    barrierDismissible: false,
    context: context,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/logo.png'),
        Container(
          child: CircularProgressIndicator(),
        ),
      ],
    ),
    // child: Center(
    //   child: Container(
    //     height: 50,
    //     width: 50,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset('assets/logo.png'),
    //         CircularProgressIndicator(),
    //       ],
    //     ),
    //   ),
    // ),
  );
}
