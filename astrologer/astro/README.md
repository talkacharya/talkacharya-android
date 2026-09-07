# TalkAcharya — Astrologer app

Flutter app for astrologers (availability, incoming consultations, earnings, payouts).
Package name `astro` is legacy; the store identity is `com.talkacharya.astrologer`.

Same architecture as the customer app — see
[`../../customer/customr/README.md`](../../customer/customr/README.md) for the full
layout and stack notes. Differences:

| | Customer (`customr`) | Astrologer (`astro`) |
|---|---|---|
| App id | `com.talkacharya.customer` | `com.talkacharya.astrologer` |
| Theme seed | saffron | indigo |
| API surface | `/app/...` | `/astro/...` |
| Post-login | discovery / wallet | availability / requests / earnings |

## Running

```bash
flutter pub get
dart run build_runner build
flutter run --flavor dev -t lib/main_dev.dart
# or against a LAN host:
flutter run --flavor dev -t lib/main_dev.dart \
  --dart-define=API_BASE_URL=http://192.168.1.5:8000/api/v1
```

## Dev login (no SMS)

With the backend running in dev mode and `python manage.py seed_dev_accounts` done,
enter **`9565901765`** (demo astrologer, an approved profile). OTP is the last 6 digits
— `901765` — pre-filled by the app. See
[backend/docs/mobile.md](../../../backend/docs/mobile.md).

## Tests

```bash
flutter analyze
flutter test
```
