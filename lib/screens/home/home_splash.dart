import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class HomeSplash extends StatefulWidget {
  final UserRepository userRepository;

  const HomeSplash({Key key, this.userRepository}) : super(key: key);

  @override
  _HomeSplashState createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
