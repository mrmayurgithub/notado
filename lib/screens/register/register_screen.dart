import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;

  const RegisterScreen({Key key, this.userRepository}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
