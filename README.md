# Energy OS - Flutter

Your Biological Operating System - A comprehensive health and wellness tracking app built with Flutter and Supabase.

## Features

- **Today Tab**: View your daily rhythm pulse, morning brief, meal timeline, and sleep-fuel sync
- **Fuel Tab**: Meal scanner with AI, nutrition tracking, feeling cards, and chef's recommendations
- **Train Tab**: Workout planner, recovery tracking, mode selection (Performance/Recovery/Aesthetic/Longevity)
- **Mind Tab**: Guided meditation, journaling, breathing exercises, and sleep preparation
- **Evolve Tab**: Biology model tracking, AI pattern discovery, trigger insights, and forecasts
- **Tribe Tab**: Community feed, live events, challenges, and social features
- **Full Settings**: Profile management, account security, notifications, privacy, and more
- **Inbox System**: Briefs, nudges, and saved recommendations
- **AI Coach**: Ask questions across all tabs for personalized recommendations

## Tech Stack

- **Frontend**: Flutter 3.9+
- **State Management**: Riverpod
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Realtime**: Supabase Realtime
- **AI Features**: 12 Edge Functions for recommendations and insights

## Prerequisites

- Flutter SDK 3.9 or higher
- Dart SDK 3.9 or higher
- Supabase account and project
- Android Studio / Xcode for platform-specific development

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd energyos
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create a `.env` file in the root directory:

```bash
cp .env.example .env
```

Edit `.env` and add your Supabase credentials:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### 4. Update Constants

Edit `lib/utils/constants.dart` and update the Supabase configuration:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

### 5. Run the App

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## Database Schema

The app uses 10 main tables:

1. **users** - User profiles and energy levels
2. **energy_logs** - Energy tracking over time
3. **meals** - Meal logs with nutrition data
4. **workouts** - Workout sessions
5. **sleep_logs** - Sleep tracking
6. **feelings** - Mood and feeling tracking
7. **forecasts** - AI-generated predictions
8. **recommendations** - Saved coach recommendations
9. **briefs** - Voice briefs and summaries
10. **community_feed** - Social activity feed

## Supabase Edge Functions

The backend includes 12 Edge Functions:

1. `mind_routine` - Generate meditation/breathing routines
2. `training_plan` - Create workout plans
3. `meal_plan` - Generate meal recommendations
4. `meal_photo_ai` - Analyze meal photos with AI
5. `barcode_scan` - Get nutrition from barcodes
6. `sleep_post` - Log sleep data
7. `workouts_post` - Log workout data
8. `energy_update` - Recalculate energy levels
9. `voice_input` - Transcribe voice to text
10. `generate_brief` - Create voice summaries
11. `tribe_feed` - Get community feed
12. `energy_forecast` - Generate energy predictions

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (10 models)
├── services/                 # Backend services
│   ├── energy_api.dart      # Edge Functions wrapper
│   ├── auth_service.dart    # Authentication
│   ├── database_service.dart # Database queries
│   ├── storage_service.dart  # File uploads
│   └── realtime_service.dart # Live updates
├── providers/                # Riverpod providers
├── screens/                  # All app screens
│   ├── auth/                # Login, signup, onboarding
│   ├── tabs/                # 6 main tabs
│   ├── settings/            # Settings and sub-screens
│   └── inbox/               # Inbox and briefs
├── widgets/                  # Reusable widgets
└── utils/                    # Constants, theme, validators
```

## Key Features Implementation

### Authentication Flow
- Sign up with email/password
- Login with session management
- Onboarding to collect user profile
- Password reset functionality

### AI Coach Integration
- Text and voice input
- Real-time recommendations
- Context-aware responses across tabs
- Save recommendations to planner

### Real-time Features
- Live community feed updates
- Energy level synchronization
- Tribe activity tracking

### Offline Support
- Local caching with shared preferences
- Optimistic UI updates
- Sync when back online

## Platform-Specific Setup

### Android

Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS

Add permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan your meals</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for voice input</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to save meal photos</string>
```

## Build for Production

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Troubleshooting

### Supabase Connection Issues
- Verify your SUPABASE_URL and SUPABASE_ANON_KEY are correct
- Check that your Supabase project is active
- Ensure Edge Functions are deployed

### Camera Not Working
- Check platform-specific permissions are added
- Test on physical device (camera doesn't work on simulators)

### Build Errors
- Run `flutter clean` and `flutter pub get`
- Check Flutter and Dart SDK versions
- Update dependencies: `flutter pub upgrade`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is proprietary software. All rights reserved.

## Support

For support, email: support@energyos.app

---

Built with ❤️ using Flutter and Supabase
