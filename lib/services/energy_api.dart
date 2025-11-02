import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class EnergyAPI {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Generic function call wrapper
  Future<dynamic> call(String functionName, Map<String, dynamic> body) async {
    try {
      final response = await _supabase.functions.invoke(
        functionName,
        body: body,
      );
      
      if (response.status != 200) {
        throw Exception('Function call failed: ${response.data}');
      }
      
      return response.data;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  // Mind Tab - Generate meditation/breathing routines
  Future<Map<String, dynamic>> getMindRoutine(String query) async {
    return await call(AppConstants.mindRoutineFunction, {'query': query});
  }

  // Train Tab - Generate workout plans
  Future<Map<String, dynamic>> getTrainingPlan(String query) async {
    return await call(AppConstants.trainingPlanFunction, {'query': query});
  }

  // Fuel Tab - Generate meal plans
  Future<Map<String, dynamic>> getMealPlan({String? query, List<String>? ingredients}) async {
    final body = <String, dynamic>{};
    if (query != null) body['query'] = query;
    if (ingredients != null) body['ingredients'] = ingredients;
    return await call(AppConstants.mealPlanFunction, body);
  }

  // Fuel Tab - Scan meal photo with AI
  Future<Map<String, dynamic>> scanMealPhoto(String photoUrl) async {
    return await call(AppConstants.mealPhotoAIFunction, {'image_url': photoUrl});
  }

  // Fuel Tab - Scan barcode
  Future<Map<String, dynamic>> scanBarcode(String barcode, {bool log = true}) async {
    return await call(AppConstants.barcodeScanFunction, {'upc': barcode, 'log': log});
  }

  // Fuel Tab - Log meal manually
  Future<Map<String, dynamic>> logMeal({
    String? title,
    String? photoUrl,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    Map<String, dynamic>? macros,
    String source = 'manual',
  }) async {
    return await call(AppConstants.logMealFunction, {
      if (title != null) 'title': title,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (macros != null) 'macros': macros,
      'source': source,
    });
  }

  // Today Tab - Log sleep
  Future<Map<String, dynamic>> postSleep(double hours, int qualityScore) async {
    return await call(AppConstants.sleepPostFunction, {
      'hours': hours,
      'quality_score': qualityScore,
    });
  }

  // Train Tab - Log workout
  Future<Map<String, dynamic>> postWorkout(Map<String, dynamic> workoutData) async {
    return await call(AppConstants.workoutsPostFunction, workoutData);
  }

  // Update energy level (called after any log)
  Future<Map<String, dynamic>> updateEnergy(String source) async {
    return await call(AppConstants.energyUpdateFunction, {'source': source});
  }

  // Voice input - transcribe audio
  Future<Map<String, dynamic>> transcribeVoice(String audioBase64) async {
    return await call(AppConstants.voiceInputFunction, {'audio_b64': audioBase64});
  }

  // Generate voice brief (morning/evening/monthly)
  Future<Map<String, dynamic>> generateBrief(String kind) async {
    return await call(AppConstants.generateBriefFunction, {'kind': kind});
  }

  // Tribe Tab - Get feed and online count
  Future<Map<String, dynamic>> getTribeFeed() async {
    return await call(AppConstants.tribeFeedFunction, {});
  }

  // Evolve Tab - Get energy forecast
  Future<List<dynamic>> getEnergyForecast() async {
    return await call(AppConstants.energyForecastFunction, {});
  }

  // Helper: Ask coach based on tab type
  Future<Map<String, dynamic>> askCoach(String tabType, String query) async {
    switch (tabType) {
      case 'mind':
        return await getMindRoutine(query);
      case 'train':
        return await getTrainingPlan(query);
      case 'fuel':
        return await getMealPlan(query: query);
      default:
        throw Exception('Unknown tab type: $tabType');
    }
  }

  // Community Feed - Post to feed
  Future<Map<String, dynamic>> postToFeed({
    required String type,
    required String message,
    String? emoji,
    bool isPublic = true,
  }) async {
    return await call('feed_post', {
      'type': type,
      'message': message,
      'emoji': emoji,
      'is_public': isPublic,
    });
  }

  // Challenges - Join or interact with challenge
  Future<Map<String, dynamic>> challengeAction({
    required String action,
    required String challengeId,
  }) async {
    return await call('challenges_join', {
      'action': action,
      'challenge_id': challengeId,
    });
  }

  // Challenges - Admin create challenge
  Future<Map<String, dynamic>> createChallenge({
    required String name,
    String? mode,
    int durationDays = 7,
    DateTime? startsAt,
    int? maxParticipants,
    Map<String, dynamic>? rules,
  }) async {
    return await call('challenges_admin', {
      'name': name,
      'mode': mode,
      'duration_days': durationDays,
      'starts_at': (startsAt ?? DateTime.now()).toIso8601String(),
      'max_participants': maxParticipants,
      'rules': rules ?? {},
    });
  }
}

