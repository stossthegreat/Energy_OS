class MealModel {
  final String id;
  final String userId;
  final DateTime at;
  final String? title;
  final String? photoUrl;
  final String source; // 'manual', 'photo', 'barcode', 'ai'
  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final Map<String, dynamic> macros;

  MealModel({
    required this.id,
    required this.userId,
    required this.at,
    this.title,
    this.photoUrl,
    this.source = 'manual',
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.macros = const {},
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      at: DateTime.parse(json['at'] as String),
      title: json['title'] as String?,
      photoUrl: json['photo_url'] as String?,
      source: json['source'] as String? ?? 'manual',
      calories: (json['calories'] as num?)?.toDouble(),
      proteinG: (json['protein_g'] as num?)?.toDouble(),
      carbsG: (json['carbs_g'] as num?)?.toDouble(),
      fatG: (json['fat_g'] as num?)?.toDouble(),
      macros: json['macros'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'at': at.toIso8601String(),
      'title': title,
      'photo_url': photoUrl,
      'source': source,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'macros': macros,
    };
  }
}

