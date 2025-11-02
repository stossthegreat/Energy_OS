class WorkoutModel {
  final String id;
  final String userId;
  final DateTime at;
  final String type;
  final int? durationMin;
  final double? intensityRpe; // 1-10
  final String? notes;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.at,
    required this.type,
    this.durationMin,
    this.intensityRpe,
    this.notes,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      at: DateTime.parse(json['at'] as String),
      type: json['type'] as String,
      durationMin: json['duration_min'] as int?,
      intensityRpe: (json['intensity_rpe'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'at': at.toIso8601String(),
      'type': type,
      'duration_min': durationMin,
      'intensity_rpe': intensityRpe,
      'notes': notes,
    };
  }
}

