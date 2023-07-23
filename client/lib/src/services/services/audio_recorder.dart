
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorder {
  String recordFilePath = "";

  Future<bool> checkPermission() async {
    // check if platform is web
    // if (kIsWeb) {
    //   window.navigator.getUserMedia(audio: true).then((MediaStream stream) {
    //     return true;
    //   }).catchError((e) {
    //     return false;
    //   });
    //   return true;
    // }
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    recordFilePath = await getFilePath();
    print(recordFilePath);
    RecordMp3.instance.start(recordFilePath, (type) {});
  }

  bool stopRecord() {
    return RecordMp3.instance.stop();
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    String file = "$sdPath/mic_recording.mp3";
    sdPath = "${storageDirectory.path}/record/temp";
    d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return file;
  }
}
