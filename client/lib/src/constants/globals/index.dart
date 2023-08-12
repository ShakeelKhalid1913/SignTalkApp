import 'package:client/src/models/transcript.model.dart';
import 'package:client/src/services/services/audio_recorder.dart';
import 'package:client/src/widgets/character.widget.dart';
import 'package:flutter/material.dart';

Transcript transcript = Transcript(text: '');
const int minRecordingTime = 2; // in seconds
AudioRecorder audioRecorder = AudioRecorder();
final GlobalKey<CharacterState> characterKey = GlobalKey();