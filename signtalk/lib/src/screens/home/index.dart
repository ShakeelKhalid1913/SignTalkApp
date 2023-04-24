import 'package:flutter/material.dart';
import 'package:signtalk/src/widgets/character.widget.dart';
import 'package:signtalk/src/screens/home/widgets/popup_menu.dart';
import 'package:signtalk/src/screens/home/widgets/voice_input_textfield.dart';
import 'package:signtalk/src/screens/home/widgets/text_transcriber.dart';
import '../../config/services/audio_recorder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  String _method = "None";

  void setMethodOfTranscript(String val) => setState(() => _method = val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Sign Talk"),
        automaticallyImplyLeading: false,
        actions: [
          CustomPopupMenu(
            setMethodOfTranscript: setMethodOfTranscript
            )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextMicInputWidget(
              inputController: _inputController,
              setMethodOfTranscript: setMethodOfTranscript,
              audioRecorder: _audioRecorder,
            ),
            const Character(),
            if (_method != "None")
              TranscribeTextBuilder(
                method: _method,
                audioRecorder: _audioRecorder,
                setMethodOfTranscript: setMethodOfTranscript,
              ),
          ],
        ),
      ),
    );
  }
}
