# 🤖 Energy OS - Android Build Guide

## 📦 Build APK Locally

### Prerequisites
- Flutter SDK 3.x
- Java JDK 17+
- Android SDK

### Quick Build (Debug)
```bash
cd /home/felix/energy_os
flutter pub get
flutter build apk --debug
```

**Output**: `build/app/outputs/flutter-apk/app-debug.apk`

---

## 🔐 Release Build with Signing

### Step 1: Generate Signing Key (First Time Only)

```bash
cd android

# Generate upload keystore
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Enter passwords and info when prompted:
# - Store password (remember this!)
# - Key password (can be same as store password)
# - Name, Organization, City, State, Country
```

### Step 2: Create key.properties

```bash
cd /home/felix/energy_os/android
cp key.properties.template key.properties

# Edit key.properties with your details:
nano key.properties
```

**Example `key.properties`**:
```properties
storePassword=YourStorePassword123
keyPassword=YourKeyPassword123
keyAlias=upload
storeFile=../upload-keystore.jks
```

### Step 3: Build Release APK

```bash
cd /home/felix/energy_os
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

### Step 4: Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

---

## 🚀 GitHub Actions (CI/CD)

The repository includes a GitHub Actions workflow that automatically builds APK on every push.

### Setup GitHub Secrets

To enable signed builds in CI/CD, add these secrets to your GitHub repo:

**Settings → Secrets and variables → Actions → New repository secret**

1. **`KEYSTORE_BASE64`**
   ```bash
   # Convert your keystore to base64
   base64 -i android/upload-keystore.jks | tr -d '\n' > keystore.txt
   # Copy contents of keystore.txt to GitHub secret
   ```

2. **`STORE_PASSWORD`**
   - Your keystore password

3. **`KEY_PASSWORD`**
   - Your key password

4. **`KEY_ALIAS`**
   - Your key alias (usually "upload")

### Workflow Triggers

The workflow runs on:
- ✅ Push to `main` or `master` branch
- ✅ Pull requests
- ✅ Manual trigger (Actions tab → Build Android APK → Run workflow)

### Download Built APKs

After a successful workflow run:
1. Go to **Actions** tab
2. Click on the latest workflow run
3. Scroll to **Artifacts**
4. Download `energyos-release-apk`

---

## 📱 Install APK on Device

### Method 1: ADB Install
```bash
# Connect device via USB and enable USB debugging
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Method 2: Direct Transfer
1. Copy APK to phone
2. Open file manager
3. Tap APK file
4. Allow "Install from unknown sources" if prompted
5. Tap "Install"

---

## 🏪 Publish to Google Play Store

### 1. Create Play Console Account
- https://play.google.com/console
- One-time $25 registration fee

### 2. Create App Listing
- App name: **Energy OS**
- Package name: `com.energyos.app`
- Upload screenshots, description, etc.

### 3. Upload App Bundle
```bash
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab`

### 4. Complete Store Listing
- Screenshots (phone + tablet)
- App icon (512x512)
- Feature graphic (1024x500)
- Description
- Privacy policy URL
- Content rating

### 5. Submit for Review
- Create a release
- Add release notes
- Submit for review (takes 1-7 days)

---

## 🔍 Verify Build

### Check APK Info
```bash
# View APK details
aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep -E 'package|version'

# Expected output:
# package: name='com.energyos.app' versionCode='1' versionName='1.0.0'
```

### Check Signing
```bash
# Verify APK is signed
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Should show: "jar verified"
```

### APK Size
```bash
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Typical size: 20-40 MB
```

---

## 🛠️ Troubleshooting

### Error: "key.properties not found"
**Solution**: Copy template and fill in your details
```bash
cp android/key.properties.template android/key.properties
nano android/key.properties
```

### Error: "Execution failed for task ':app:signReleaseBundle'"
**Solution**: Check your passwords in `key.properties` are correct

### Error: "The plugin image_picker requires Android SDK version 34"
**Solution**: Already set in `build.gradle.kts` (compileSdk = 34)

### Error: "Minimum supported Gradle version is 8.0"
**Solution**: Update gradle wrapper (already configured)

### APK Too Large
**Solution**: Enable ProGuard/R8 (currently disabled for debugging)
```kotlin
// In android/app/build.gradle.kts
buildTypes {
    release {
        minifyEnabled = true
        shrinkResources = true
    }
}
```

---

## 📊 Build Variants

### Debug Build (Fast)
```bash
flutter build apk --debug
# ~50 MB, includes debugging symbols
```

### Profile Build (Performance Testing)
```bash
flutter build apk --profile
# Optimized but with profiling enabled
```

### Release Build (Production)
```bash
flutter build apk --release
# ~20-30 MB, fully optimized
```

### Split APKs by ABI (Smaller Size)
```bash
flutter build apk --split-per-abi --release
# Generates separate APKs for arm64-v8a, armeabi-v7a, x86_64
```

---

## 🔄 Version Bumping

Update version in `pubspec.yaml`:
```yaml
version: 1.0.1+2  # 1.0.1 is version name, 2 is version code
```

Then rebuild:
```bash
flutter pub get
flutter build apk --release
```

---

## ✅ Pre-Publish Checklist

- [ ] App name set to "Energy OS" in `AndroidManifest.xml`
- [ ] Package name is `com.energyos.app`
- [ ] Version number updated in `pubspec.yaml`
- [ ] Release APK builds successfully
- [ ] APK is signed (not debug keystore)
- [ ] Tested on physical device
- [ ] All permissions justified
- [ ] Privacy policy URL added
- [ ] Screenshots prepared (min 2)
- [ ] App icon finalized

---

## 🎯 Quick Commands Reference

```bash
# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle --release

# Install on connected device
flutter install

# Run on device
flutter run --release

# Clean build
flutter clean && flutter pub get && flutter build apk --release
```

---

**Ready to build? Run:**
```bash
cd /home/felix/energy_os
flutter build apk --release
```

🚀 **APK will be at**: `build/app/outputs/flutter-apk/app-release.apk`

