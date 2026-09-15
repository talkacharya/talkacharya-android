# Releasing the customer app

Run from Git Bash in `android/customer/customr`. `make help` lists every target.

## One-time setup

1. **Upload keystore** — `android/app/upload-keystore.jks` + `android/key.properties`
   (template: `android/key.properties.example`). Both are gitignored; keep a backup
   outside the repo. Without them a release build is signed with the *debug* key
   (fine for QA, rejected by Play).
2. **Fingerprints** — `make signing-report` prints SHA-1/SHA-256 for debug and release.
   Add all of them in Firebase console → Project settings → *TalkAcharya (customer)*.
   After the first Play upload also add the **Play App Signing** key's SHA-1/SHA-256
   (Play Console → Test and release → App integrity → App signing). Re-download
   `google-services.json` afterwards.
3. **App Check** (see *Firebase login / App Check* below).
4. **Crashlytics** — enable it in Firebase console → Crashlytics. `npm i -g firebase-tools`
   and `firebase login` once, for `make symbols-upload`.

## Build & ship

```bash
make check                                   # format + analyze + tests
make appbundle BUILD_NUMBER=12 BUILD_NAME=1.0.3
make symbols-upload FLAVOR=prod              # Dart symbols → readable Crashlytics traces
```

- `BUILD_NUMBER` must go up for every Play upload.
- Release builds are R8-minified + resource-shrunk (`android/app/proguard-rules.pro`)
  and Dart-obfuscated; the R8 mapping uploads to Crashlytics automatically.
- QA APK for a phone: `make apk-release FLAVOR=prod APP_CHECK_PROVIDER=debug` (a
  sideloaded build can't pass Play Integrity — register its debug token instead).
- Icons / splash come from `assets/icons/logo.png`: `make branding` regenerates both.

## Firebase login / App Check

Phone sign-in fails with *"We couldn't verify this copy of the app"* (debug builds append
the raw Firebase code) when App Check or app verification rejects the device.

| Build | App Check provider | What must be registered |
|---|---|---|
| `make run` / any debug build | Debug | This install's debug token (`make appcheck-token`) in App Check → Apps → ⋮ → Manage debug tokens |
| dev / staging release APK | Debug | Same — per install |
| prod release installed **from Play** | Play Integrity | App Check → Apps → Play Integrity with the **Play App Signing** SHA-256; Cloud project linked in Play Console; *Play Integrity API* enabled in Google Cloud |
| prod release **sideloaded** | Play Integrity → always fails | Build with `APP_CHECK_PROVIDER=debug` for testing |

Checklist when login fails:

1. `adb logcat | grep -iE "FirebasePhoneAuth|App Check|debug secret"` — the app logs the
   Firebase error code and which provider it used.
2. Debug provider → is this device's token in *Manage debug tokens*? (A reinstall or
   "clear data" makes a new token.)
3. Firebase console → Authentication → Sign-in method → **Phone** enabled; project on
   **Blaze**.
4. SHA-1 **and** SHA-256 for the signing key in Project settings (debug, upload *and*
   Play App Signing).
5. App Check → APIs → *Authentication*: if **Enforced**, every unregistered device fails.
   Switch to *Unenforced* while rolling out, watch the verified-request metric, then enforce.
6. Testing without SMS: Authentication → Sign-in method → Phone → *Phone numbers for
   testing*.

Backend side: `APP_CHECK_MODE=monitor` + `FIREBASE_PROJECT_NUMBER` in
`deploy/compose/.env` verifies the `X-Firebase-AppCheck` header on the login endpoints and
logs failures; switch to `enforce` once `app_check.rejected` logs are quiet.
