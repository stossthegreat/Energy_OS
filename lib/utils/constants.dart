class AppConstants {
  // Tab Gradients
  static const List<String> todayGradient = ['#fbbf24', '#f97316', '#f43f5e'];
  static const List<String> fuelGradient = ['#34d399', '#14b8a6', '#06b6d4'];
  static const List<String> trainGradient = ['#a78bfa', '#c026d3', '#ec4899'];
  static const List<String> mindGradient = ['#818cf8', '#8b5cf6', '#9333ea'];
  static const List<String> evolveGradient = ['#60a5fa', '#06b6d4', '#14b8a6'];
  static const List<String> tribeGradient = ['#f472b6', '#f43f5e', '#dc2626'];
  
  // Supabase (to be set via environment)
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  
  // App Text
  static const String appName = 'ENERGY OS';
  static const String appTagline = 'Your Biological Operating System';
  
  // Database Tables
  static const String usersTable = 'users';
  static const String energyLogsTable = 'energy_logs';
  static const String mealsTable = 'meals';
  static const String workoutsTable = 'workouts';
  static const String sleepLogsTable = 'sleep_logs';
  static const String feelingsTable = 'feelings';
  static const String forecastsTable = 'forecasts';
  static const String recommendationsTable = 'recommendations';
  static const String briefsTable = 'briefs';
  static const String communityFeedTable = 'community_feed';
  
  // Edge Functions
  static const String mindRoutineFunction = 'mind_routine';
  static const String trainingPlanFunction = 'training_plan';
  static const String mealPlanFunction = 'meal_plan';
  static const String mealPhotoAIFunction = 'photo_meal_analyze';
  static const String barcodeScanFunction = 'barcode_lookup';
  static const String logMealFunction = 'log_meal';
  static const String sleepPostFunction = 'sleep_post';
  static const String workoutsPostFunction = 'workouts_post';
  static const String energyUpdateFunction = 'energy_update';
  static const String voiceInputFunction = 'voice_input';
  static const String generateBriefFunction = 'generate_brief';
  static const String tribeFeedFunction = 'tribe_feed';
  static const String energyForecastFunction = 'energy_forecast';
  static const String feedPostFunction = 'feed_post';
  static const String challengesJoinFunction = 'challenges_join';
  static const String challengesAdminFunction = 'challenges_admin';
  static const String notifyLowEnergyFunction = 'notify_low_energy';
  
  // Storage Buckets
  static const String mealPhotosBucket = 'meal-photos';
  static const String avatarsBucket = 'avatars';
  
  // Shared Preferences Keys
  static const String lastInboxViewKey = 'last_inbox_view';
  static const String userModeKey = 'user_mode';
}

