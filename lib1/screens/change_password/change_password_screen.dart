import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class ChnangePasswordScreen extends StatefulWidget {
  final UserRepository userRepository;

  const ChnangePasswordScreen({Key key, @required this.userRepository})
      : super(key: key);
  @override
  _ChnangePasswordScreenState createState() => _ChnangePasswordScreenState();
}

class _ChnangePasswordScreenState extends State<ChnangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: Text('Change Password'),
          ),
          Form(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(),
                  SizedBox(height: 20),
                  TextFormField(),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.green,
                    onPressed: () {},
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
