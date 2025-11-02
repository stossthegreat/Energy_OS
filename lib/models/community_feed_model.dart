class CommunityFeedModel {
  final String id;
  final String userId;
  final String? activity;
  final String? mode;
  final String? message;
  final DateTime createdAt;

  CommunityFeedModel({
    required this.id,
    required this.userId,
    this.activity,
    this.mode,
    this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CommunityFeedModel.fromJson(Map<String, dynamic> json) {
    return CommunityFeedModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      activity: json['activity'] as String?,
      mode: json['mode'] as String?,
      message: json['message'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'activity': activity,
      'mode': mode,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

