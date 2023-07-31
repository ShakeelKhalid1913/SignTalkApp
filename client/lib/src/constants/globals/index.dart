import 'package:client/src/models/transcript.model.dart';
import 'package:client/src/services/services/audio_recorder.dart';

Transcript transcript = Transcript(text: '');
String transcriptMethod = "None";
const int minRecordingTime = 2; // in seconds
AudioRecorder audioRecorder = AudioRecorder();
