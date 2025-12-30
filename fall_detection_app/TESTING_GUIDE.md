# Firebase Connection - Testing Guide

## Setup Awal Sebelum Testing

### 1. Ensure Firebase Realtime Database Has Correct Rules
Go to Firebase Console → Realtime Database → Rules

Set rules to allow read/write:
```json
{
  "rules": {
    "device_data": {
      ".read": true,
      ".write": true
    },
    "user_profile": {
      ".read": true,
      ".write": true
    }
  }
}
```

Click "Publish" to apply rules.

### 2. Ensure Sample Data Exists in Firebase
The database should have structure like:
```json
{
  "device_data": {
    "status": "Normal",
    "lastUpdate": 1700000000,
    "location": {
      "latitude": -6.969,
      "longitude": 107.6282
    },
    "history": {
      "item1": {
        "status": "Normal",
        "timestamp": 1700000000
      },
      "item2": {
        "status": "Terdeteksi Jatuh",
        "timestamp": 1699990000
      }
    }
  },
  "user_profile": {
    "username": "Firebase User",
    "email": "firebase@test.com",
    "phoneNumber": "081234567890",
    "emergencyContact": {
      "nama": "John Doe",
      "hubungan": "Son",
      "telepon": "081122334455"
    }
  }
}
```

---

## Testing Steps

### Test 1: User Profile Loading at Startup ✓

**Expected:**
- App opens and immediately loads user profile from Firebase
- Header shows "Welcome [username from Firebase]"
- Profile page shows user data from Firebase

**How to Test:**
1. Stop current app if running: Press `q` in terminal
2. Run: `flutter run -d [device_id]`
3. Wait for app to fully load
4. Check that username appears in header
5. Navigate to Profile page
6. Verify user data matches Firebase database

**Debug:**
```bash
# Watch logs for ProfileController initialization
flutter logs | grep -i "ProfileController\|Firebase\|UserService"
```

---

### Test 2: Home Page Status & History ✓

**Expected:**
- Status shows current device status from Firebase
- Last update time is formatted correctly
- History shows last 3 items from Firebase
- All data displays in real-time

**How to Test:**
1. Open app and go to Home page
2. Check status displays (should not show "Error")
3. Check "Update terakhir:" shows a time
4. Check "Riwayat Singkat" shows history items
5. Change device_data/status in Firebase Console → should update in app within 3-5 seconds
6. Add new history item in Firebase Console → should appear in app

**Debug:**
```bash
flutter logs | grep -E "HomeController:|HomeService:|Snapshot|Dashboard"
```

**Expected Logs:**
```
HomeController: Starting to listen for dashboard data...
HomeService: Event diterima dari Firebase! Exists: true
HomeController: Data berhasil dimuat. Status: [status_value]
```

---

### Test 3: Edit Profile & Save to Firebase ✓

**Expected:**
- Edit profile page opens with current user data
- Can modify all fields
- Click "Save Changes" sends data to Firebase
- Success message appears
- After saving, data in Firebase is updated
- Profile page reflects the new data

**How to Test:**
1. Open app, go to Profile
2. Click "Edit Profile"
3. Change username to something like "Test User 123"
4. Change email to "test@email.com"
5. Change emergency contact name to "Emergency Person"
6. Click "Save Changes"
7. Should see "Profile berhasil diperbarui!" message
8. Check Firebase Console → user_profile → verify changes
9. Go back and open Edit Profile again → should show updated data

**Debug:**
```bash
flutter logs | grep -E "UserService|Firebase|update|Error"
```

**Expected Logs:**
```
UserService: Mengambil profil dari '/user_profile'...
UserService: Snapshot diterima. Exists: true
ProfileController: Data berhasil dimuat.
# After saving:
[No specific log, check Firebase Console for updated data]
```

---

### Test 4: Error Handling ✓

**Expected:**
- If Firebase unavailable, status shows "Error"
- Edit profile shows error message if save fails
- Error messages are user-friendly

**How to Test:**
1. Turn off device internet
2. Open app → status should show "Error"
3. Try to edit profile → should show error message
4. Turn internet back on
5. Refresh app → should load properly again

---

### Test 5: Location Tracking ✓

**Expected:**
- Map displays with location from Firebase (device_data/location)
- Location shows latitude & longitude from database

**How to Test:**
1. Open Home page
2. Scroll down to "Location Tracking"
3. Map should show location based on Firebase data
4. Current sample: (-6.969, 107.6282)
5. Change coordinates in Firebase → map should update (restart app or wait for stream update)

---

## Logs to Monitor

### Firebase Connection Logs
```
Main: ProfileController initialized
ProfileController: Fetching user profile...
UserService: Mengambil profil dari '/user_profile'...
HomeController: Starting to listen for dashboard data...
HomeService: Event diterima dari Firebase! Exists: true
```

### Update Logs
```
UserService: Snapshot diterima. Exists: true
HomeController: Data berhasil dimuat. Status: [status]
ProfileController: Profile berhasil diperbarui
```

### Error Logs
```
UserService Error: [error message]
Error in dashboard stream: [error message]
Error processing home data: [error message]
Error saving profile: [error message]
```

---

## Troubleshooting

### Issue: Status shows "Error"
**Solution:**
1. Check internet connection
2. Check Firebase Rules are set correctly
3. Verify device_data exists in Firebase
4. Check Firebase project ID in firebase_options.dart

### Issue: User data not loading
**Solution:**
1. Check user_profile exists in Firebase
2. Check email and username fields exist
3. Check device has internet connectivity
4. Look for "Error fetching profile:" in logs

### Issue: Edit Profile save fails
**Solution:**
1. Check Firebase Rules allow write
2. Check internet connection
3. Check field values are not null/empty
4. Look for error message on screen

### Issue: History not showing
**Solution:**
1. Ensure history field exists in Firebase
2. Ensure history items have "status" and "timestamp" fields
3. Timestamp should be Unix epoch (seconds)
4. Check HomeService logs for "Parsing Error"

### Issue: App crashes on startup
**Solution:**
1. Run: `flutter pub get`
2. Run: `flutter run -v` to see full error logs
3. Check for null pointer exceptions in ProfileController initialization
4. Ensure ProfileController is properly initialized in main.dart

---

## Command Reference

### Run with Full Logs
```bash
flutter run -v
```

### Run on Specific Device
```bash
flutter devices  # List all devices
flutter run -d <device_id>
```

### Watch Specific Logs
```bash
flutter logs | grep -E "Firebase|Service|Error"
```

### Clear and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### Test on Android Emulator (if no physical device)
```bash
flutter emulators
flutter emulators launch <emulator_name>
flutter run
```

---

## Firebase Console Checks

1. **Realtime Database**
   - Check data structure under /device_data and /user_profile
   - Monitor rules are correct
   - Watch for active connections in "Connections" tab

2. **Authentication** (if implemented)
   - Check user accounts if using auth

3. **Rules**
   - Go to Rules tab
   - Ensure read: true and write: true for testing
   - Click "Test Connections" to verify

---

## Performance Notes

- ProfileController loads user data once at app startup
- HomeController listens to stream for real-time updates
- Status updates should appear within 1-3 seconds of Firebase change
- Edit Profile saves are asynchronous with loading indicator

---

## Success Criteria Checklist

- [ ] App loads and shows user name from Firebase
- [ ] Status displays without "Error"
- [ ] History shows at least 1-3 items
- [ ] Location map displays
- [ ] Edit Profile can be opened with current data
- [ ] Save Profile updates Firebase
- [ ] User profile changes reflect in all pages
- [ ] No crashes or exceptions in logs
- [ ] Notifications page shows history items
- [ ] Emergency contacts display correctly

---

## Notes

- All data is case-sensitive in Firebase
- Timestamp should be in Unix epoch format (seconds)
- Location must have both latitude and longitude
- Emergency contact keys are: "nama", "hubungan", "telepon"
- Main profile keys are: "username", "email", "phoneNumber"

