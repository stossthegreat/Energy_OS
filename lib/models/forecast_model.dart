class ForecastModel {
  final String id;
  final String userId;
  final DateTime date;
  final String? energyPeakTime;
  final String? energyLowTime;
  final double confidence; // 0-1
  final DateTime createdAt;

  ForecastModel({
    required this.id,
    required this.userId,
    required this.date,
    this.energyPeakTime,
    this.energyLowTime,
    required this.confidence,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      energyPeakTime: json['energy_peak_time'] as String?,
      energyLowTime: json['energy_low_time'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'energy_peak_time': energyPeakTime,
      'energy_low_time': energyLowTime,
      'confidence': confidence,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

