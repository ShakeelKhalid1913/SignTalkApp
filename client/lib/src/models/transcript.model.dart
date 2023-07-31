class Transcript {
  String text;

  Transcript({required this.text});

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(text: json['text'] ?? "");
  }
}
