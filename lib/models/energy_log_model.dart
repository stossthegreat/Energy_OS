class EnergyLogModel {
  final String id;
  final String userId;
  final DateTime at;
  final String source; // 'sleep', 'meal', 'training', 'mood', 'recalc'
  final double energyDelta;
  final int energyLevel; // 0-100
  final Map<String, dynamic> factors;

  EnergyLogModel({
    required this.id,
    required this.userId,
    required this.at,
    required this.source,
    required this.energyDelta,
    required this.energyLevel,
    this.factors = const {},
  });

  factory EnergyLogModel.fromJson(Map<String, dynamic> json) {
    return EnergyLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      at: DateTime.parse(json['at'] as String),
      source: json['source'] as String,
      energyDelta: (json['energy_delta'] as num).toDouble(),
      energyLevel: json['energy_level'] as int,
      factors: json['factors'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'at': at.toIso8601String(),
      'source': source,
      'energy_delta': energyDelta,
      'energy_level': energyLevel,
      'factors': factors,
    };
  }
}

