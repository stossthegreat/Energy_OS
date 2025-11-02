import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/energy_api.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../services/realtime_service.dart';
import 'user_provider.dart';

// Energy API Provider
final energyAPIProvider = Provider<EnergyAPI>((ref) {
  return EnergyAPI();
});

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Realtime Service Provider
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService();
});

// Today's Meals Provider
final todayMealsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getTodayMeals(userData.id);
});

// Recent Workouts Provider
final recentWorkoutsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getWorkouts(userData.id, limit: 10);
});

// Latest Sleep Provider
final latestSleepProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return null;
  
  return await db.getLatestSleep(userData.id);
});

// Energy Logs Provider (7 days)
final energyLogsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getEnergyLogs(userData.id, days: 7);
});

// Recommendations Provider
final recommendationsProvider = FutureProvider.family<List<dynamic>, String?>((ref, tab) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getRecommendations(userData.id, tab: tab);
});

// Briefs Provider
final briefsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getBriefs(userData.id);
});

// Community Feed Provider
final communityFeedProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getCommunityFeed(limit: 50);
});

// Forecasts Provider
final forecastsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseServiceProvider);
  final userData = await ref.watch(userDataProvider.future);
  
  if (userData == null) return [];
  
  return await db.getForecasts(userData.id, days: 7);
});

