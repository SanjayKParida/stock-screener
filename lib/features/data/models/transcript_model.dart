import '../../domain/entities/transcript.dart';

class TranscriptModel extends Transcript {
  const TranscriptModel({required super.transcript});

  factory TranscriptModel.fromJson(Map<String, dynamic> json) {
    return TranscriptModel(
      transcript: json['transcript'] ?? '',
    );
  }
}
