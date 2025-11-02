import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

// Database Service Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// User Data Provider (from database)
final userDataProvider = StreamProvider<UserModel?>((ref) async* {
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) {
    yield null;
    return;
  }

  final db = ref.watch(databaseServiceProvider);
  
  // Initial fetch
  try {
    final userProfile = await ref.watch(authServiceProvider).getUserProfile();
    yield userProfile;
  } catch (e) {
    yield null;
  }
});

// Energy Level Provider
final energyLevelProvider = Provider<double>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData.asData?.value?.energyLevel ?? 50.0;
});

