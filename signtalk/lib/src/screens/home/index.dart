import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signtalk/src/screens/home/popup.menu.dart';
import 'package:signtalk/src/screens/home/text_mic.input.dart';
import 'package:signtalk/src/widgets/appdrawer.widget.dart';
import '../../config/services/audio_recorder.dart';
import '../../constants/globals/index.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  String _statusText = "";
  String _method = "None";

  void setStatusText(String value) {
    setState(() {
      _statusText = value;
    });
  }

  void setMethodOfTranscript(String val) {
    setState(() {
      _method = val;
    });
  }

  Future<String> transcript(String method) async {
    print(method);
    if (method == "Mic")
      return await globals
          .transcriptFile(_audioRecorder.recordFilePath)
          .then((value) => value)
          .catchError(
              (error) => "Error in transcripting file: ${error.toString()}");
    else if (method == "File") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['wav', 'mp3', 'm4a', 'mp4'],
        type: FileType.custom,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return await globals
            .transcriptFile(file.path)
            .then((value) => value)
            .catchError(
                (error) => "Error in transcripting file: ${error.toString()}");
      } else
        return "File did not pick";
    } else
      return "No method selected";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Talk"),
          centerTitle: true,
          actions: [
            CustomPopupMenu(setMethodOfTranscript: setMethodOfTranscript)
          ],
          // automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextMicInputWidget(
                inputController: _inputController,
                setStatusText: setStatusText,
                setMethodOfTranscript: setMethodOfTranscript,
                audioRecorder: _audioRecorder,
              ),
              // Character(),
              if (_method != "None")
                FutureBuilder<String>(
                  future: transcript(_method),
                  builder: (context, snapshot) {
                    List<Widget> children;
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        children = [Text('Error: ${snapshot.error}')];
                      } else {
                        final responseText = snapshot.data ?? "";
                        children = [Text(responseText)];
                      }
                    } else {
                      children = [
                        SizedBox(
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        ),
                      ];
                    }
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                ),
              Text(_statusText)
              // Character()
            ],
          ),
        ),
        drawer: AppDrawer());
  }
}
