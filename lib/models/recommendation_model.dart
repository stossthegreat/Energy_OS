class RecommendationModel {
  final String id;
  final String userId;
  final Map<String, dynamic> context; // {tab, scenario, query, ...}
  final Map<String, dynamic> output; // coach JSON response
  final DateTime createdAt;

  RecommendationModel({
    required this.id,
    required this.userId,
    required this.context,
    required this.output,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      context: json['context'] as Map<String, dynamic>,
      output: json['output'] as Map<String, dynamic>,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'context': context,
      'output': output,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

