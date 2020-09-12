import 'package:flutter/material.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/services/search_service.dart';
import 'package:notado/user_repository/user_Repository.dart';

class SearchScreen extends StatefulWidget {
  final UserRepository userRepository;
  final String uid;

  const SearchScreen(
      {Key key, @required this.userRepository, @required this.uid})
      : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toLowerCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService()
          .searchByName(value, widget.uid)
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          print(docs.documents[i]['title'].toString() + "title....");
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        print(element['title'].toString() + ".............title......element");
        if (element['title'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    print(tempSearchStore.length.toString() +
        "................searchitems.............");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (val) {
            initiateSearch(val);
          },
          decoration: InputDecoration(
              prefixIcon: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Search by name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
      SizedBox(height: 10.0),
      GridView.count(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          primary: false,
          shrinkWrap: true,
          children: tempSearchStore.map((element) {
            return buildResultCard(element);
          }).toList())
    ]));
  }
}

Widget buildResultCard(data) {
  print(data.toString() + '........datadatatadatadtad');
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(
        data['title'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ))));
}
