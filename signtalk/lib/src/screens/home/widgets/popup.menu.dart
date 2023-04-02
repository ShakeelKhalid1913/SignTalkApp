import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/theme.dart';
import '../../../models/enums/options.dart';

class CustomPopupMenu extends StatefulWidget {
  final Function(String) setMethodOfTranscript;

  CustomPopupMenu({super.key, required this.setMethodOfTranscript});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  Options? _selectedOption;

  Future<dynamic> dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Youtube Video URL'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Youtube Video URL',
              ),
            ),
            actions: [
              Text("This process can take a while"),
              ElevatedButton(
                child: Text('Load'),
                onPressed: () {
                  // Do something with the text input
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: _selectedOption,
      onSelected: (Options option) {
        setState(() => _selectedOption = option);
      },
      itemBuilder: (context) => <PopupMenuEntry<Options>>[
        PopupMenuItem<Options>(
          value: Options.file,
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.fileImport,
              color: Themes.kColor,
            ),
            title: Text("Upload File"),
            onTap: () {
              widget.setMethodOfTranscript("File");
            },
          ),
        ),
        PopupMenuItem<Options>(
          value: Options.url,
          child: ListTile(
            leading: FaIcon(FontAwesomeIcons.youtube, color: Themes.kColor),
            title: Text("Load Youtube Video"),
            onTap: dialog,
          ),
        ),
      ],
    );
  }
}
