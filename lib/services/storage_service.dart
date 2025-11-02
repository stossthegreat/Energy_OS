import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Upload meal photo
  Future<String> uploadMealPhoto(File file, String userId) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '$userId/$fileName';

      await _supabase.storage
          .from(AppConstants.mealPhotosBucket)
          .upload(path, file);

      final url = _supabase.storage
          .from(AppConstants.mealPhotosBucket)
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  // Upload avatar
  Future<String> uploadAvatar(File file, String userId) async {
    try {
      final fileName = 'avatar_$userId.jpg';
      final path = fileName;

      // Delete old avatar if exists
      try {
        await _supabase.storage
            .from(AppConstants.avatarsBucket)
            .remove([path]);
      } catch (_) {
        // Ignore if file doesn't exist
      }

      await _supabase.storage
          .from(AppConstants.avatarsBucket)
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      final url = _supabase.storage
          .from(AppConstants.avatarsBucket)
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Avatar upload failed: $e');
    }
  }

  // Delete meal photo
  Future<void> deleteMealPhoto(String photoUrl) async {
    try {
      // Extract path from public URL
      final uri = Uri.parse(photoUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(AppConstants.mealPhotosBucket);
      
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final path = pathSegments.sublist(bucketIndex + 1).join('/');
        await _supabase.storage
            .from(AppConstants.mealPhotosBucket)
            .remove([path]);
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }
}

