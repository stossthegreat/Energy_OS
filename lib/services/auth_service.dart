import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up new user
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Sign up failed');
      }

      // Create user record in users table
      final userData = {
        'auth_id': authResponse.user!.id,
        'email': email,
        'name': name,
        'energy_level': 50.0,
        'timezone': 'UTC',
        'premium_tier': 'free',
      };

      final response = await _supabase
          .from(AppConstants.usersTable)
          .insert(userData)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }

  // Sign in existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in error: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out error: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Password update error: $e');
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );
    } catch (e) {
      throw Exception('Email update error: $e');
    }
  }

  // Get user profile from database
  Future<UserModel?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from(AppConstants.usersTable)
          .select()
          .eq('auth_id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
}

