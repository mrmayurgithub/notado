import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
