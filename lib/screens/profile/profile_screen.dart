import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository userRepository;
  final String photoUrl;

  const ProfileScreen({Key key, this.userRepository, @required this.photoUrl})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = "Username";
  _getDisplayName() async {
    displayName = await widget.userRepository.getDisplayName();
  }

  @override
  void initState() {
    _getDisplayName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.photoUrl == null
                ? CircleAvatar(
                    backgroundColor: Colors.green,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Hero(
                      tag: 'profilepic',
                      child: Image(
                        image: NetworkImage(
                          widget.photoUrl,
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(displayName),
                tileColor: Colors.grey[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ListTile(
                leading: Icon(Icons.person),
                tileColor: Colors.grey[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ListTile(
                leading: Icon(Icons.mail_outline),
                tileColor: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
