import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_feed_model.dart';
import '../utils/constants.dart';

class RealtimeService {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _feedChannel;

  // Subscribe to community feed updates
  Stream<CommunityFeedModel> subscribeToCommunityFeed() {
    _feedChannel = _supabase
        .channel('public:${AppConstants.communityFeedTable}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: AppConstants.communityFeedTable,
          callback: (payload) {},
        );

    final controller = StreamController<CommunityFeedModel>();

    _supabase
        .channel('community_feed_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: AppConstants.communityFeedTable,
          callback: (payload) {
            if (payload.newRecord != null) {
              controller.add(CommunityFeedModel.fromJson(payload.newRecord));
            }
          },
        )
        .subscribe();

    return controller.stream;
  }

  // Subscribe to user energy level changes
  Stream<Map<String, dynamic>> subscribeToEnergyUpdates(String userId) {
    final controller = StreamController<Map<String, dynamic>>();

    _supabase
        .channel('user_energy_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: AppConstants.usersTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (payload) {
            if (payload.newRecord != null) {
              controller.add(payload.newRecord);
            }
          },
        )
        .subscribe();

    return controller.stream;
  }

  // Unsubscribe from all channels
  void dispose() {
    _feedChannel?.unsubscribe();
  }
}

