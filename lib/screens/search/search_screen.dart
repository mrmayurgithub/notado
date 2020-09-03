import 'package:flutter/material.dart';
import 'package:notado/user_repository/user_Repository.dart';

class SearchScreen extends StatefulWidget {
  final UserRepository userRepository;

  const SearchScreen({Key key, this.userRepository}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search your notes',
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
