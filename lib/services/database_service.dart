import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/meal_model.dart';
import '../models/workout_model.dart';
import '../models/sleep_log_model.dart';
import '../models/energy_log_model.dart';
import '../models/feeling_model.dart';
import '../models/forecast_model.dart';
import '../models/recommendation_model.dart';
import '../models/brief_model.dart';
import '../models/community_feed_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Users
  Future<UserModel> getUser(String userId) async {
    final response = await _supabase
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(response);
  }

  Future<UserModel> updateUser(String userId, Map<String, dynamic> updates) async {
    final response = await _supabase
        .from(AppConstants.usersTable)
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
    return UserModel.fromJson(response);
  }

  // Meals
  Future<List<MealModel>> getMeals(String userId, {int limit = 50}) async {
    final response = await _supabase
        .from(AppConstants.mealsTable)
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(limit);
    return (response as List).map((e) => MealModel.fromJson(e)).toList();
  }

  Future<MealModel> createMeal(Map<String, dynamic> mealData) async {
    final response = await _supabase
        .from(AppConstants.mealsTable)
        .insert(mealData)
        .select()
        .single();
    return MealModel.fromJson(response);
  }

  Future<List<MealModel>> getTodayMeals(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final response = await _supabase
        .from(AppConstants.mealsTable)
        .select()
        .eq('user_id', userId)
        .gte('timestamp', startOfDay.toIso8601String())
        .order('timestamp', ascending: true);
    
    return (response as List).map((e) => MealModel.fromJson(e)).toList();
  }

  // Workouts
  Future<List<WorkoutModel>> getWorkouts(String userId, {int limit = 50}) async {
    final response = await _supabase
        .from(AppConstants.workoutsTable)
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(limit);
    return (response as List).map((e) => WorkoutModel.fromJson(e)).toList();
  }

  Future<WorkoutModel> createWorkout(Map<String, dynamic> workoutData) async {
    final response = await _supabase
        .from(AppConstants.workoutsTable)
        .insert(workoutData)
        .select()
        .single();
    return WorkoutModel.fromJson(response);
  }

  // Sleep Logs
  Future<SleepLogModel?> getLatestSleep(String userId) async {
    final response = await _supabase
        .from(AppConstants.sleepLogsTable)
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(1);
    
    if (response.isEmpty) return null;
    return SleepLogModel.fromJson(response.first);
  }

  Future<SleepLogModel> createSleepLog(Map<String, dynamic> sleepData) async {
    final response = await _supabase
        .from(AppConstants.sleepLogsTable)
        .insert(sleepData)
        .select()
        .single();
    return SleepLogModel.fromJson(response);
  }

  // Energy Logs
  Future<List<EnergyLogModel>> getEnergyLogs(String userId, {int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    
    final response = await _supabase
        .from(AppConstants.energyLogsTable)
        .select()
        .eq('user_id', userId)
        .gte('timestamp', since.toIso8601String())
        .order('timestamp', ascending: true);
    
    return (response as List).map((e) => EnergyLogModel.fromJson(e)).toList();
  }

  // Feelings
  Future<List<FeelingModel>> getFeelings(String userId, {int limit = 50}) async {
    final response = await _supabase
        .from(AppConstants.feelingsTable)
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(limit);
    return (response as List).map((e) => FeelingModel.fromJson(e)).toList();
  }

  Future<FeelingModel> createFeeling(Map<String, dynamic> feelingData) async {
    final response = await _supabase
        .from(AppConstants.feelingsTable)
        .insert(feelingData)
        .select()
        .single();
    return FeelingModel.fromJson(response);
  }

  // Forecasts
  Future<List<ForecastModel>> getForecasts(String userId, {int days = 7}) async {
    final response = await _supabase
        .from(AppConstants.forecastsTable)
        .select()
        .eq('user_id', userId)
        .order('date', ascending: true)
        .limit(days);
    return (response as List).map((e) => ForecastModel.fromJson(e)).toList();
  }

  // Recommendations
  Future<List<RecommendationModel>> getRecommendations(
    String userId, {
    String? tab,
    int limit = 50,
  }) async {
    var query = _supabase
        .from(AppConstants.recommendationsTable)
        .select()
        .eq('user_id', userId);
    
    if (tab != null) {
      query = query.eq('tab', tab);
    }
    
    final response = await query
        .order('created_at', ascending: false)
        .limit(limit);
    
    return (response as List).map((e) => RecommendationModel.fromJson(e)).toList();
  }

  Future<RecommendationModel> createRecommendation(Map<String, dynamic> data) async {
    final response = await _supabase
        .from(AppConstants.recommendationsTable)
        .insert(data)
        .select()
        .single();
    return RecommendationModel.fromJson(response);
  }

  Future<void> deleteRecommendation(String id) async {
    await _supabase
        .from(AppConstants.recommendationsTable)
        .delete()
        .eq('id', id);
  }

  // Briefs
  Future<List<BriefModel>> getBriefs(String userId, {int limit = 20}) async {
    final response = await _supabase
        .from(AppConstants.briefsTable)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List).map((e) => BriefModel.fromJson(e)).toList();
  }

  Future<BriefModel?> getLatestBrief(String userId, String kind) async {
    final response = await _supabase
        .from(AppConstants.briefsTable)
        .select()
        .eq('user_id', userId)
        .eq('kind', kind)
        .order('created_at', ascending: false)
        .limit(1);
    
    if (response.isEmpty) return null;
    return BriefModel.fromJson(response.first);
  }

  // Community Feed
  Future<List<CommunityFeedModel>> getCommunityFeed({int limit = 50}) async {
    final response = await _supabase
        .from(AppConstants.communityFeedTable)
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List).map((e) => CommunityFeedModel.fromJson(e)).toList();
  }

  Future<CommunityFeedModel> createFeedItem(Map<String, dynamic> data) async {
    final response = await _supabase
        .from(AppConstants.communityFeedTable)
        .insert(data)
        .select()
        .single();
    return CommunityFeedModel.fromJson(response);
  }
}

