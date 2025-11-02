class FeelingModel {
  final String id;
  final String userId;
  final DateTime at;
  final int? energy; // 1-10
  final int? mood; // 1-10
  final int? stress; // 1-10
  final String? notes;

  FeelingModel({
    required this.id,
    required this.userId,
    required this.at,
    this.energy,
    this.mood,
    this.stress,
    this.notes,
  });

  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      at: DateTime.parse(json['at'] as String),
      energy: json['energy'] as int?,
      mood: json['mood'] as int?,
      stress: json['stress'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'at': at.toIso8601String(),
      'energy': energy,
      'mood': mood,
      'stress': stress,
      'notes': notes,
    };
  }
}

