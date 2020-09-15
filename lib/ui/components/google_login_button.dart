import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notado/global/constants.dart';

class GoogleButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  GoogleButton({@required this.title, @required this.onPressed})
      : assert(onPressed != null),
        assert(title != null);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: buttonBorderRadius,
      color: Colors.transparent,
      elevation: 2.0,
      shadowColor: Colors.grey[400].withOpacity(0.2),
      child: RaisedButton(
        onPressed: onPressed,
        elevation: 0.0,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01500953),
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: buttonBorderRadius,
          side: BorderSide(
            width: 1.0,
            color: Colors.grey[500].withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/google.svg',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              height: screenWidth * 0.068055556,
              width: screenWidth * 0.068055556,
            ),
            SizedBox(
              width: screenWidth * 0.051041667,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: screenHeight * 0.017789072,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
