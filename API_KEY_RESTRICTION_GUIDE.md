# API Key Restriction Guide - KEEP YOUR APP WORKING

## ⚠️ IMPORTANT: Don't Delete Keys - Restrict Them Instead!

Deleting the API keys will break your app. Instead, add restrictions to secure them.

## Step-by-Step Instructions:

### 1. For Android API Key:
1. Click "Edit API key" on the Android key
2. Under "Application restrictions":
   - Select "Android apps"
   - Add package name: `com.dbestech.jobhubv2_0`
   - Add SHA-1 fingerprint: `FD:C2:AD:87:B6:B4:F5:6C:B2:6D:DE:87:76:87:7A:6C:18:BE:94:42`
3. Under "API restrictions":
   - Select "Restrict key"
   - Enable only: Firebase services you use
4. Click "Save"

### 2. For iOS API Key:
1. Click "Edit API key" on the iOS key
2. Under "Application restrictions":
   - Select "iOS apps"
   - Add Bundle ID: `com.example.jobhubv20`
3. Under "API restrictions":
   - Select "Restrict key"
   - Enable only: Firebase services you use
4. Click "Save"

### 3. For Web/Browser API Key:
1. Click "Edit API key" on the Web key
2. Under "Application restrictions":
   - Select "HTTP referrers (web sites)"
   - Add your domain: `your-domain.com/*` (if you have one)
   - Add `localhost:*` for development
3. Under "API restrictions":
   - Select "Restrict key"
   - Enable only: Firebase services you use
4. Click "Save"

## What Firebase Services to Enable:
Check these based on what your app uses:
- ✅ Firebase Authentication API
- ✅ Cloud Firestore API
- ✅ Firebase Storage API
- ✅ Firebase Realtime Database API
- ✅ Firebase Cloud Messaging API

## Find Your Package Names:
- **Android**: Check `android/app/build.gradle` → `applicationId`
- **iOS**: Check `ios/Runner.xcodeproj` → Bundle Identifier

## Result:
- ✅ Your app keeps working
- ✅ Keys are restricted to your app only
- ✅ Security issue resolved
- ✅ No unauthorized usage possible

## Alternative - If You Want New Keys:
If you prefer completely new keys:
1. Create new Firebase project
2. Add your apps to new project
3. Download new config files
4. Replace in your code
5. Delete old project
