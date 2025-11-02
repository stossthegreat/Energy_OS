class BriefModel {
  final String id;
  final String userId;
  final String kind; // 'morning', 'evening'
  final DateTime forDate;
  final String transcript;
  final String audioUrl;
  final DateTime createdAt;

  BriefModel({
    required this.id,
    required this.userId,
    required this.kind,
    required this.forDate,
    required this.transcript,
    required this.audioUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BriefModel.fromJson(Map<String, dynamic> json) {
    return BriefModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      kind: json['kind'] as String,
      forDate: DateTime.parse(json['for_date'] as String),
      transcript: json['transcript'] as String,
      audioUrl: json['audio_url'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'kind': kind,
      'for_date': forDate.toIso8601String().split('T')[0],
      'transcript': transcript,
      'audio_url': audioUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

