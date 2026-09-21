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

Uses the same `Makefile` targets as the customer app (`make help`):

```bash
make setup
make run                                              # flavor dev
make run API_BASE_URL=http://192.168.1.5:8000/api/v1   # a LAN host
make check                                             # format-check + analyze + test
```

## Dev login (no SMS)

With the backend running in dev mode and `python manage.py seed_dev_accounts` done,
enter **`9565901765`** (demo astrologer, an approved profile). OTP is the last 6 digits
— `901765` — pre-filled by the app. See
[backend/docs/mobile.md](../../../backend/docs/mobile.md).

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

**An incoming consultation rings like a call.** The backend sends the invite as
a data-only, high-priority push with a short TTL. With the app open, the realtime
frame opens the in-app request sheet. Otherwise the FCM background isolate raises
a full-screen-intent notification on the `talkacharya_incoming_call` channel — the
phone's ringtone, `FLAG_INSISTENT` so it keeps ringing, Accept/Decline actions,
and `timeoutAfter` set to the accept window. Whichever gets there first cancels
the other.

## Tests

```bash
flutter analyze
flutter test
```
