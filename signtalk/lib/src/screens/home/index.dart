import 'package:flutter/material.dart';
import 'package:signtalk/src/screens/home/widgets/character.widget.dart';
import 'package:signtalk/src/screens/home/widgets/popup.menu.dart';
import 'package:signtalk/src/screens/home/widgets/text_mic.input.dart';
import 'package:signtalk/src/screens/home/widgets/transcribe_text.builder.dart';
import '../../config/services/audio_recorder.dart';
import '../../constants/colors.dart';

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
        color: AppColors.whiteColor,
        child: Column(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            // Character()
          ],
        ),
      ),
      //drawer: AppDrawer()
    );
  }
}
