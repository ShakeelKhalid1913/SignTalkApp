import 'package:client/src/screens/home/widgets/popup_menu.dart';
import 'package:client/src/widgets/character.widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _method = "None";

  void setMethodOfTranscript(String val) {
    setState(() => _method = val);

    print(_method);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(width: 8),
            Text('SignTalk'),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          CustomPopupMenu(setMethodOfTranscript: setMethodOfTranscript)
        ],
      ),
      body: Character(
        setMethodOfTranscript: setMethodOfTranscript,
        method: _method,
      ),
    );
  }
}
