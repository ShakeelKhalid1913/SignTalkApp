import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signtalk/src/constants/colors.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final List<Widget> aboutBoxChildren = <Widget>[
    const SizedBox(height: 24),
    RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              style: TextStyle(color: AppColors.blackColor),
              text:
                  "We are team of deveolpers who have created this app to help "
                  "to communicate with the people who are deaf and hard of hearing. "
                  "We are dedicated to creating high-quality mobile applications that "
                  "make your life "
                  "easier. Our apps are designed with a focus on usability, "
                  "performance, and user experience."),
          TextSpan(
              text: 'www.signtalk.com',
              style: TextStyle(color: AppColors.kColor)),
          TextSpan(text: '.', style: TextStyle(color: AppColors.blackColor)),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            leading: FaIcon(FontAwesomeIcons.question, color: AppColors.kColor),
            title: Text(
              "Help",
            ),
            onTap: () {},
          ),
          AboutListTile(
            icon: FaIcon(FontAwesomeIcons.circleInfo, color: AppColors.kColor),
            applicationIcon: ImageIcon(
              AssetImage('assets/images/icon1.png'),
            ),
            applicationName: 'Sign Talk',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2023 Company',
            aboutBoxChildren: aboutBoxChildren,
            child: Text('About app'),
          ),
        ],
      ),
    );
  }
}
