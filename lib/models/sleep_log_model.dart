class SleepLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final double? hours;
  final int? qualityScore; // 0-100
  final double? hrvMs;

  SleepLogModel({
    required this.id,
    required this.userId,
    required this.date,
    this.hours,
    this.qualityScore,
    this.hrvMs,
  });

  factory SleepLogModel.fromJson(Map<String, dynamic> json) {
    return SleepLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      hours: (json['hours'] as num?)?.toDouble(),
      qualityScore: json['quality_score'] as int?,
      hrvMs: (json['hrv_ms'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'hours': hours,
      'quality_score': qualityScore,
      'hrv_ms': hrvMs,
    };
  }
}

