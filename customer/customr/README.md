# TalkAcharya — Customer app

Flutter app for customers (browse astrologers, consult, wallet). Package name `customr`
is legacy; the store identity is `com.talkacharya.customer`.

## Stack

| Concern | Choice |
|---|---|
| State | `flutter_bloc` (Bloc + Cubit) |
| Navigation | `go_router` with an auth-gated `redirect` |
| Networking | `dio` + `AuthInterceptor` (bearer, 401 → refresh → replay) |
| Models | `freezed` + `json_serializable` |
| Token storage | `flutter_secure_storage` |
| DI | `get_it` |

## Layout

```
lib/
  main.dart / main_dev.dart / main_staging.dart / main_prod.dart   # flavor entrypoints
  bootstrap.dart                # binding, error hooks, DI, runApp
  src/
    app/                        # App widget + splash
    core/
      config/flavor.dart        # Flavor enum + AppConfig (API base URL per flavor)
      constants/api_paths.dart
      di/service_locator.dart
      network/                  # dio_client, auth_interceptor, api_exception
      router/app_router.dart    # routes + auth redirect
      storage/token_storage.dart
      theme/app_theme.dart
      utils/validators.dart
    features/
      auth/
        data/                   # auth_api, auth_repository, models/
        presentation/
          bloc/auth/            # AuthBloc — app session
          bloc/login/           # LoginCubit — phone → OTP flow
          view/                 # phone_page, otp_page, login_page
      home/
    shared/widgets/
```

## Running

Flavors are required (`dev` / `staging` / `prod`), each paired with a `main_*.dart`:

```bash
flutter pub get
dart run build_runner build            # generate *.freezed.dart / *.g.dart

# local backend (Django on :8000, emulator reaches host at 10.0.2.2)
flutter run --flavor dev -t lib/main_dev.dart

# point at another host / a device on your LAN:
flutter run --flavor dev -t lib/main_dev.dart \
  --dart-define=API_BASE_URL=http://192.168.1.5:8000/api/v1
```

## Dev login (no SMS)

The backend's `config.settings.local` runs OTP in **dev mode**. Start it and seed the
demo accounts:

```bash
cd ../../../backend
python manage.py migrate
python manage.py seed_dev_accounts
python manage.py runserver 0.0.0.0:8000
```

Then in the app enter **`6388952128`** (demo customer). The OTP is the phone's last 6
digits — `952128` — and the app pre-fills it and shows a "Dev mode" banner. Set
`OTP_DEV_CODE=112233` in the backend env for a single fixed code instead.

## Tests

```bash
flutter analyze
flutter test
```
