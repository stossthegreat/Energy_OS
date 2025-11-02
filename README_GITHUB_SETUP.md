# 📤 Push Energy OS to GitHub

## 🚀 Quick Setup

### Step 1: Initialize Git (if not already)
```bash
cd /home/felix/energy_os
git init
```

### Step 2: Create .gitignore (already done ✅)
The repository already has a proper `.gitignore` that excludes:
- Signing keys (`*.jks`, `*.keystore`, `key.properties`)
- Build artifacts
- IDE files
- Dependencies

### Step 3: Initial Commit
```bash
# Add all files
git add .

# Commit
git commit -m "Initial commit: Energy OS Flutter app with Supabase backend"
```

### Step 4: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `energy-os` (or your choice)
3. Description: "Energy OS - Your Biological Operating System. Flutter app with Supabase backend, AI Coach, and energy tracking."
4. **Keep it Private** (for now, since it has API keys in docs)
5. **Do NOT initialize with README** (we already have one)
6. Click "Create repository"

### Step 5: Link and Push
```bash
# Add remote (replace USERNAME with your GitHub username)
git remote add origin https://github.com/USERNAME/energy-os.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## 🔐 Setup GitHub Secrets (for CI/CD)

### Navigate to Repository Settings
1. Go to your repository on GitHub
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**

### Add These Secrets

#### 1. **KEYSTORE_BASE64** (Required for signed builds)
```bash
# First, generate a keystore if you haven't:
cd /home/felix/energy_os/android
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Convert to base64
base64 -w 0 upload-keystore.jks > keystore.txt

# Copy the content of keystore.txt and paste as secret value
cat keystore.txt
```

#### 2. **STORE_PASSWORD**
- Value: The password you entered when creating the keystore

#### 3. **KEY_PASSWORD**
- Value: The key password (usually same as store password)

#### 4. **KEY_ALIAS**
- Value: `upload` (or whatever you used)

### ⚠️ **IMPORTANT**
- Never commit `key.properties` or `*.jks` files to git
- The `.gitignore` already excludes them
- Only store them in GitHub Secrets for CI/CD

---

## 🤖 Enable GitHub Actions

GitHub Actions is automatically enabled when you push the `.github/workflows/build-apk.yml` file.

### First Build
After pushing to GitHub:
1. Go to **Actions** tab
2. You should see "Build Android APK" workflow running
3. Wait ~5-10 minutes for the build to complete
4. Download the APK from the **Artifacts** section

### Manual Trigger
1. Go to **Actions** tab
2. Click "Build Android APK" workflow
3. Click **Run workflow** button
4. Select branch (main)
5. Click **Run workflow**

---

## 📁 Repository Structure

After pushing, your repo will look like:

```
energy-os/
├── .github/
│   └── workflows/
│       └── build-apk.yml           ← GitHub Actions workflow
├── android/                         ← Android project
│   ├── app/
│   │   ├── build.gradle.kts        ← Build config (updated!)
│   │   └── src/
│   │       └── main/
│   │           └── AndroidManifest.xml  ← Permissions (updated!)
│   ├── key.properties.template     ← Signing template
│   └── *.jks (NOT in git)          ← Your keystore (local only)
├── lib/                             ← Flutter app code
│   ├── models/                      ← 12 models
│   ├── services/                    ← 5 services
│   ├── screens/                     ← 30+ screens
│   └── main.dart
├── supabase/
│   ├── functions/                   ← 14 Edge Functions
│   └── migrations/                  ← 4 SQL migrations
├── pubspec.yaml                     ← Dependencies
├── README.md                        ← Main documentation
├── ANDROID_BUILD.md                 ← Build instructions
├── DEPLOYMENT_GUIDE.md              ← Backend deployment
├── AUDIT_REPORT.md                  ← Audit results
└── .gitignore                       ← Excludes secrets
```

---

## 🏷️ Create a Release (Optional)

### Tag a Version
```bash
# Create a tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to GitHub
git push origin v1.0.0
```

### Automatic Release
When you push a tag starting with `v` (like `v1.0.0`), the GitHub Actions workflow will:
1. Build the APK
2. Create a GitHub Release
3. Attach the APK to the release

Users can then download the APK directly from the Releases page!

---

## 🔄 Update Workflow

### Push Changes
```bash
# After making changes
git add .
git commit -m "Description of changes"
git push origin main
```

### The workflow will automatically:
1. ✅ Build APK
2. ✅ Run Flutter analyze
3. ✅ Upload artifacts
4. ✅ Create release (if tagged)

---

## 🎨 Add a README Badge

Add this to the top of your `README.md` to show build status:

```markdown
![Build Status](https://github.com/USERNAME/energy-os/actions/workflows/build-apk.yml/badge.svg)
```

Replace `USERNAME` with your GitHub username.

---

## 🌐 Make Repository Public (Later)

**Before making public**:
1. ✅ Remove any API keys from code (use environment variables)
2. ✅ Review all documentation for sensitive info
3. ✅ Add LICENSE file (MIT, Apache, etc.)
4. ✅ Update README with setup instructions

**To make public**:
1. Go to repository **Settings**
2. Scroll to "Danger Zone"
3. Click "Change visibility"
4. Select "Public"

---

## 📊 Monitor Builds

### View Build Logs
1. **Actions** tab
2. Click on a workflow run
3. Click on "build" job
4. Expand steps to see logs

### Common Issues
- **Build fails**: Check `flutter analyze` output
- **Signing fails**: Verify GitHub secrets are set correctly
- **Dependencies fail**: Update `pubspec.yaml` versions

---

## ✅ Checklist

Before pushing to GitHub:

- [ ] Review `.gitignore` (excludes secrets) ✅
- [ ] No API keys in code (moved to env vars) ✅
- [ ] README is complete ✅
- [ ] Android build config updated ✅
- [ ] GitHub Actions workflow created ✅
- [ ] Generate signing keystore (local)
- [ ] Create GitHub repository
- [ ] Add GitHub secrets
- [ ] Push code
- [ ] Verify Actions workflow runs
- [ ] Download built APK

---

## 🚀 Ready to Push!

```bash
cd /home/felix/energy_os

# Make sure everything is committed
git status

# If there are uncommitted changes:
git add .
git commit -m "Ready for deployment"

# Create remote and push
git remote add origin https://github.com/YOUR_USERNAME/energy-os.git
git branch -M main
git push -u origin main
```

**After push, check**:
- ✅ Files appear on GitHub
- ✅ Actions tab shows workflow running
- ✅ Build completes successfully
- ✅ APK artifact is available for download

---

**All set! Your Energy OS app is now on GitHub with automated builds! 🎉**

