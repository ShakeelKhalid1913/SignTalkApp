import 'package:flutter/material.dart';
import 'package:signtalk/src/constants/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //create drawer with avatar and name
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Shakeel Khalid"),
            accountEmail: Text("shakeelkhalid786@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Text("SK", style: TextStyle(fontSize: 20)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Themes.kColor,
            ),
            title: Text(
              "Help",
              textScaleFactor: 1.5,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Themes.kColor,
            ),
            title: Text(
              "About",
              textScaleFactor: 1.5,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
