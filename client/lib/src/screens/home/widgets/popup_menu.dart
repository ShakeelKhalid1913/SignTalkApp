import 'package:client/src/screens/videoplayer/index.dart';
import 'package:client/src/widgets/character.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:client/src/constants/colors.dart';
import 'package:client/src/models/enums/options.enum.dart';
import 'package:client/src/models/transcript.model.dart';
import 'package:client/src/constants/globals/index.dart' as globals;
import 'package:client/src/services/services/api_services.dart' as api_services;

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({super.key});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  final TextEditingController _controller = TextEditingController();
  Options? _selectedOption;

  final List<Widget> aboutBoxChildren = <Widget>[
    const SizedBox(height: 24),
    const Text(
        "We are team of students from GIFT university who have created this app to help "
        "to communicate with the people who are deaf and hard of hearing. "
        "We are dedicated to creating high-quality mobile applications that "
        "make your life "
        "easier. Our apps are designed with a focus on usability, "
        "performance, and user experience.")
  ];

  Future<dynamic> dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Youtube Video URL'),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter Youtube Video URL',
              ),
            ),
            actions: [
              const Text(
                "This process can take a while",
                style: TextStyle(color: AppColors.redColor),
              ),
              ElevatedButton(
                child: const Text('Load'),
                onPressed: () {
                  setState(() {
                    globals.transcript = Transcript(text: _controller.text);
                    //globals.transcriptMethod = "Youtube";
                  });
                  // _controller.clear();
                  debugPrint("Youtube Video URL: ${_controller.text}");
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoUrl: _controller.text,
                      ),
                    ),
                  );
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
      onSelected: (Options option) => setState(() => _selectedOption = option),
      itemBuilder: (context) => <PopupMenuEntry<Options>>[
        PopupMenuItem<Options>(
          value: Options.file,
          child: ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.fileImport,
              color: AppColors.kColor,
            ),
            title: const Text("Upload File"),
            onTap: () {
              CharacterState? state = globals.characterKey.currentState;
              if(state != null){
                state.transcript("File");
              }
            },
          ),
        ),
        PopupMenuItem<Options>(
          value: Options.url,
          child: ListTile(
            leading:
                const FaIcon(FontAwesomeIcons.youtube, color: AppColors.kColor),
            title: const Text("Load Youtube Video"),
            onTap: dialog,
          ),
        ),
        PopupMenuItem<Options>(
          value: Options.help,
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.solidCircleQuestion,
                color: AppColors.kColor),
            title: const Text("Help"),
            onTap: () {},
          ),
        ),
        PopupMenuItem<Options>(
          value: Options.about,
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.circleInfo,
                color: AppColors.kColor),
            title: const Text("About"),
            onTap: () {
              showAboutDialog(
                context: context,
                children: aboutBoxChildren,
                applicationIcon: const ImageIcon(
                  AssetImage('assets/images/logo.png'),
                ),
                applicationName: 'Sign Talk',
                applicationVersion: '1.0.0',
                applicationLegalese: '2023 Company',
              );
            },
          ),
        ),
      ],
    );
  }
}
