import 'package:flutter/material.dart';
import 'package:notado/screens/home/navigation_model.dart';

class CollapsingNavigationBar extends StatefulWidget {
  @override
  _CollapsingNavigationBarState createState() =>
      _CollapsingNavigationBarState();
}

class _CollapsingNavigationBarState extends State<CollapsingNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, i) {
            return CollapsingListTile(
              title: navigationItems[i].title,
              icon: navigationItems[i].icon,
            );
          },
        ),
      ],
    );
  }
}

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;

  const CollapsingListTile({Key key, this.title, this.icon}) : super(key: key);
  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon, color: Colors.blue),
        // sized00
      ],
    );
  }
}
