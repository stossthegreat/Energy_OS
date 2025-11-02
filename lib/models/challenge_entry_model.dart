class ChallengeEntryModel {
  final String id;
  final String challengeId;
  final String userId;
  final DateTime joinedAt;
  final Map<String, dynamic> progress;
  final double score;

  ChallengeEntryModel({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.joinedAt,
    required this.progress,
    required this.score,
  });

  factory ChallengeEntryModel.fromJson(Map<String, dynamic> json) {
    return ChallengeEntryModel(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      userId: json['user_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      progress: json['progress'] as Map<String, dynamic>? ?? {},
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'user_id': userId,
      'joined_at': joinedAt.toIso8601String(),
      'progress': progress,
      'score': score,
    };
  }
}

