# TalkAcharya — Mobile apps

Two Flutter apps against the [TalkAcharya backend](../backend):

| Folder | Project | Store id | Audience |
|---|---|---|---|
| [`customer/customr`](customer/customr) | `customr` | `com.talkacharya.customer` | customers — find & consult astrologers |
| [`astrologer/astro`](astrologer/astro) | `astro` | `com.talkacharya.astrologer` | astrologers — availability, requests, earnings |

They are **independent projects** (own `pubspec.yaml`, own build). Shared code is copied,
not packaged — keep the two `lib/src/core/` trees in step when you change one. The
architecture is identical; each README documents its differences.

## Architecture (both apps)

- **State** — `flutter_bloc`. One app-level `AuthBloc` (session), feature Cubits/Blocs
  under `lib/src/features/<feature>/presentation/bloc/`.
- **Navigation** — `go_router`, single `redirect` gate driven by `AuthBloc`.
- **Networking** — `dio`; `AuthInterceptor` attaches the bearer, and on `401` does a
  single shared refresh + replay, falling back to `AuthSessionExpired`.
- **Models** — `freezed` + `json_serializable` (`dart run build_runner build`).
- **Config** — compile-time `Flavor` (dev/staging/prod) → `AppConfig`; `API_BASE_URL`
  via `--dart-define` always wins. Android product flavors mirror the three envs.
- **Secrets** — JWT pair in `flutter_secure_storage` only.

```
<app>/lib/
  main_{dev,staging,prod}.dart   -> bootstrap(Flavor.x)
  bootstrap.dart
  src/
    app/            core/            features/          shared/
                    config/          auth/              widgets/
                    network/         home/
                    router/
                    storage/
                    theme/
```

## First run

```bash
# 1. backend in dev mode (predictable OTP, demo accounts)
cd ../backend
python manage.py migrate
python manage.py seed_dev_accounts          # +916388952128 customer, +919565901765 astrologer
python manage.py runserver 0.0.0.0:8000

# 2. an app
cd ../android/customer/customr
flutter pub get
dart run build_runner build
flutter run --flavor dev -t lib/main_dev.dart
```

Log in with the demo number for that app; the OTP is the phone's **last 6 digits** and the
app pre-fills it (dev-mode banner). Details: [backend/docs/mobile.md](../backend/docs/mobile.md).

## Per-app commands

```bash
flutter pub get
dart run build_runner build            # or: watch
flutter analyze
flutter test
flutter run   --flavor dev     -t lib/main_dev.dart
flutter build apk --flavor prod -t lib/main_prod.dart
```

CI (`.github/workflows/flutter-ci.yml`) runs `analyze` + `test` for both apps on every push.
