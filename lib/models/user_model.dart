class UserModel {
  final String id;
  final String authId;
  final String? email;
  final String? name;
  final int? age;
  final String? sex; // 'male', 'female', 'other'
  final double? weightKg;
  final double? heightCm;
  final String? goal;
  final double energyLevel;
  final String timezone;
  final String premiumTier;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.authId,
    this.email,
    this.name,
    this.age,
    this.sex,
    this.weightKg,
    this.heightCm,
    this.goal,
    this.energyLevel = 50,
    this.timezone = 'UTC',
    this.premiumTier = 'free',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      authId: json['auth_id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      age: json['age'] as int?,
      sex: json['sex'] as String?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      goal: json['goal'] as String?,
      energyLevel: (json['energy_level'] as num?)?.toDouble() ?? 50,
      timezone: json['timezone'] as String? ?? 'UTC',
      premiumTier: json['premium_tier'] as String? ?? 'free',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_id': authId,
      'email': email,
      'name': name,
      'age': age,
      'sex': sex,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'goal': goal,
      'energy_level': energyLevel,
      'timezone': timezone,
      'premium_tier': premiumTier,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? authId,
    String? email,
    String? name,
    int? age,
    String? sex,
    double? weightKg,
    double? heightCm,
    String? goal,
    double? energyLevel,
    String? timezone,
    String? premiumTier,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      authId: authId ?? this.authId,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      energyLevel: energyLevel ?? this.energyLevel,
      timezone: timezone ?? this.timezone,
      premiumTier: premiumTier ?? this.premiumTier,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

