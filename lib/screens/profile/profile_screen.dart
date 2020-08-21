import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository userRepository;

  const ProfileScreen({Key key, this.userRepository}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 150,
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
            ),
            ListTile(
              leading: Icon(Icons.mail_outline),
            ),
          ],
        ),
      ),
    );
  }
}
