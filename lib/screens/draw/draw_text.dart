import 'package:flutter/material.dart';

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
          color: Colors.black,
          //fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'R',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'A',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'W',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
