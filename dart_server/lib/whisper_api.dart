import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const apiUrl =
    "https://api-inference.huggingface.co/models/openai/whisper-large";
const token = "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";

Future<Map<String, dynamic>> query(String filename) async {
  List<int> bytes = File(filename).readAsBytesSync();

  http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/octet-stream',
    },
    body: bytes,
  );

  Map<String, dynamic> result = jsonDecode(response.body);
  return result;
}

Future<double> getDuration(String filename) async {
  // Construct the command and arguments.
  List<String> command = [
    'ffprobe',
    '-i',
    filename,
    '-show_entries',
    'format=duration',
    '-v',
    'quiet',
    '-of',
    'csv=p=0'
  ];

  // Start the process and wait for it to complete.
  ProcessResult result = await Process.run(command[0], command.sublist(1));

  // Check if the process completed successfully.
  if (result.exitCode == 0) {
    // Parse the output as a double.
    double? duration = double.tryParse(result.stdout.toString());
    if (duration != null) {
      return duration;
    } else {
      // Return a default value if the parsed value is null.
      return 0.0;
    }
  } else {
    // Throw an exception with the error message.
    throw Exception(result.stderr.toString());
  }
}

Future<void> segmentMedia(
    String filename, int subpartDuration, String ext) async {
  // Construct the command and arguments.
  List<String> command = [
    'ffmpeg',
    '-i',
    filename,
    '-c',
    'copy',
    '-map',
    '0',
    '-segment_time',
    subpartDuration.toString(),
    '-f',
    'segment',
    'temp/media_%03d.$ext'
  ];

  // Start the process and capture its output and errors.
  Process process = await Process.start(command[0], command.sublist(1));
  process.stdout.transform(utf8.decoder).listen((data) {
    print('stdout: $data');
  });
  process.stderr.transform(utf8.decoder).listen((data) {
    print('stderr: $data');
  });

  int exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('ffmpeg command failed with exit code $exitCode');
  }
}

List<String> getSubpartFilenames(
    String ext, double duration, int subpartDuration) {
  int numSubparts = (duration / subpartDuration).ceil();
  List<String> subpartFilenames = [];
  for (int i = 0; i < numSubparts; i++) {
    String filename = 'temp/media_${i.toString().padLeft(3, '0')}.$ext';
    subpartFilenames.add(filename);
  }
  return subpartFilenames;
}

void removeFiles() {
  Directory tempDir = Directory('temp');
  if (tempDir.existsSync()) {
    for (FileSystemEntity file in tempDir.listSync()) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }
}

Future<String> transcript(String filename) async {
  String transcript = "";
  print("Converting audio to text... Please wait.");

  int subpartDuration = 30;
  var data = filename.split('.');
  var ext = data[1];

  double duration = 30.0;
  getDuration(filename).then((value) => duration = value);

  await segmentMedia(filename, subpartDuration, ext);

  List<String> subpartFilenames =
      getSubpartFilenames(ext, duration, subpartDuration);
  print("${subpartFilenames.length} subparts created");

  for (String subpartFilename in subpartFilenames) {
    var result = "";
    await query(subpartFilename).then((value) {
      Map<String, dynamic> map = value;
      result = map['text'];
    });
    transcript += result;
  }

  removeFiles();

  return transcript;
}
