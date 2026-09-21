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

A `Makefile` wraps the common commands (run it from Git Bash — `make help` lists all).
Flavors are required (`dev` / `staging` / `prod`), each paired with a `main_*.dart`.

```bash
make setup                 # pub get + build_runner (once, and after dep changes)
make run                   # flavor dev -> local backend (emulator reaches host at 10.0.2.2)
make run FLAVOR=staging
make run API_BASE_URL=http://192.168.1.5:8000/api/v1   # a device on your LAN
make run DEVICE=emulator-5554
make apk-release           # release APK for the current FLAVOR
make appbundle             # prod AAB for Play

# raw equivalents, if you prefer:
flutter run --flavor dev -t lib/main_dev.dart
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

## Errors on screen

A person never sees an exception. `bootstrap` sets `showErrorDetails` from the
flavor — true for dev and staging, **false for prod** — and everything that puts
an error in front of someone goes through one of two helpers:

- `friendlyError(e)` (`core/network/friendly_error.dart`) — a short English
  sentence, for cubits and anywhere without a `BuildContext`.
- `localizedError(context, e)` / `localizedErrorFor(l, e)`
  (`core/l10n/api_error_l10n.dart`) — the same, in the user's language, keyed off
  the backend's stable error `code`.

Both fall back to a generic line and, in development only, append the technical
detail after a `[dev]` marker. Rules that keep it honest:

- `ApiException.fromServer` marks a message the backend actually wrote. A
  synthesized placeholder (`Request failed (500).`), an HTML error page or a 5xx
  body is never shown — those collapse to the generic line.
- `ApiException.toString()` is human-readable in production too, so a stray
  `'$e'` cannot leak a stack of internals. Logs and Crashlytics therefore use
  `technicalError(e)` explicitly, and lose nothing.
- `ErrorWidget.builder` replaces Flutter's red box with `AppErrorWidget`: a calm
  panel in production, the exception text in development.

`test/core/friendly_error_test.dart` holds the guarantees.

## Wallet numbers

Three figures, and they are not interchangeable:

| | where it comes from | shown as |
|---|---|---|
| balance | `cached_balance` — the sum of the ledger | "Balance ₹X" in the breakdown |
| on hold | `held_amount` — reserved by a live session | "₹X on hold", tap for why |
| spendable | `available_balance` = balance − holds | the headline figure |

`available_balance` can arrive negative when a reservation outlives the session
that made it. `WalletBalance.spendable` floors it at zero — a customer reading
"−₹1,472" learns only that something is wrong with our books — and the reserved
amount is named beside it instead. Every screen that prints a spendable figure
uses `spendable`, never `available`: the wallet card, the home chip, the profile
row, the gift sheet and the "add money to start" dialog.

The balance ticks down live during a consultation: each minute's charge publishes
`wallet.updated`, which `WalletCubit` applies before re-reading the server.

## The consultation room

**A call outlives its screen.** `CallHub` (in `talkacharya_call`) owns the one
running call; the room adopts it on open and hands it back on close. Minimizing
or navigating away leaves the call running behind a tap-to-return bar (voice) or
a draggable window (video), mounted app-wide by `CallOverlayHost` in
`MaterialApp.builder`. Only hanging up, or the room closing on an already-ended
call, releases it. Leaving the app during a **video** call goes one step further
and shrinks it into a system picture-in-picture window showing just the peer —
`MainActivity` owns that (`talkacharya/pip`), because only it sees the user
leave. The Android foreground service (`microphone|camera`) keeps
the mic alive when the whole app goes to the background.

**Sound and vibration each have one switch.** `AppSounds` (native, so silent and
vibrate mode are respected) plays the ringtone, ringback, notification and the
short chat/call tones; `HapticService` does every buzz, including the ones
inside the shared call screen, which go through the `CallHaptics` port set in
`bootstrap`. Both follow a stored preference — nothing calls `HapticFeedback` or
the platform sound directly.

**Alerts know where you are.** `RoomPresence` holds the consultation whose room
is on screen, and the shell checks it before playing a tone or showing a toast.
The router cannot answer this: the room is pushed on the root navigator, above
the shell, so the shell's own location never names it.

## Tests

```bash
make check     # format-check + analyze + test
make test ARGS='--name login'
```
