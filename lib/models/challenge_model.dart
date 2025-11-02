class ChallengeModel {
  final String id;
  final String name;
  final String? mode;
  final int durationDays;
  final DateTime startsAt;
  final int? maxParticipants;
  final Map<String, dynamic> rules;

  ChallengeModel({
    required this.id,
    required this.name,
    this.mode,
    required this.durationDays,
    required this.startsAt,
    this.maxParticipants,
    required this.rules,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mode: json['mode'] as String?,
      durationDays: json['duration_days'] as int,
      startsAt: DateTime.parse(json['starts_at'] as String),
      maxParticipants: json['max_participants'] as int?,
      rules: json['rules'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mode': mode,
      'duration_days': durationDays,
      'starts_at': startsAt.toIso8601String(),
      'max_participants': maxParticipants,
      'rules': rules,
    };
  }
}

