import 'package:flutter/material.dart';

import '../../constants/theme.dart';
import '../../models/enums/options.dart';

class CustomPopupMenu extends StatefulWidget {
  final Function(String) setMethodOfTranscript;

  CustomPopupMenu({super.key, required this.setMethodOfTranscript});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  late Options _selectedOption;

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
            leading: Icon(
              Icons.file_upload,
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
            leading: Icon(Icons.link, color: Themes.kColor),
            title: Text("Upload URL"),
          ),
        ),
      ],
    );
  }
}
