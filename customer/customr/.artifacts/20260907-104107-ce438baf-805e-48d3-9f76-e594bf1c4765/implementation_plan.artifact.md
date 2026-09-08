# Professional Astrology App Login UI/UX Overhaul

Improve the UI/UX of the `PhonePage` and `OtpPage` to make it look professional, remove hardcoded country codes (supporting worldwide users), and add auto-detecting OTP system.

## User Review Required

- **Library Additions**: I plan to add `intl_phone_number_input` for worldwide phone support and `pinput` for a professional OTP input experience.
- **Visual Style**: I will move towards a more "Celestial/Mystical" theme using the existing saffron seed but adding more depth (gradients, icons) as requested.

## Proposed Changes

### Dependencies

#### [pubspec.yaml](file:///K:/talkacharya/android/customer/customr/pubspec.yaml)
- Add `intl_phone_number_input: ^0.7.4+1`
- Add `pinput: ^5.0.0`
- Add `flutter_svg: ^2.0.10` (for professional icons)

---

### Core Improvements

#### [validators.dart](file:///K:/talkacharya/android/customer/customr/lib/src/core/utils/validators.dart)
- Update `toE164India` to a more generic `toE164` that doesn't force `+91` if the input already has a country code from the picker.

#### [login_cubit.dart](file:///K:/talkacharya/android/customer/customr/lib/src/features/auth/presentation/bloc/login/login_cubit.dart)
- Update `requestOtp` to accept full E.164 numbers from the new picker.

---

### UI Overhaul

#### [phone_page.dart](file:///K:/talkacharya/android/customer/customr/lib/src/features/auth/presentation/view/phone_page.dart)
- Replace basic `TextField` with `InternationalPhoneNumberInput`.
- Implement a more professional layout with a header icon (Astrology themed).
- Add "Why we need this?" or "We'll send a code" explanatory text.

#### [otp_page.dart](file:///K:/talkacharya/android/customer/customr/lib/src/features/auth/presentation/view/otp_page.dart)
- Replace basic `TextField` with `Pinput`.
- Implement auto-focus and auto-submit logic.
- Add "Edit Number" capability directly on the screen if possible.

## Verification Plan

### Automated Tests
- Run `flutter test test/core/validators_test.dart` to ensure phone validation still works.
- Add a new test for generic E.164 validation.

### Manual Verification
- Verify the country picker works and defaults correctly.
- Verify the OTP input looks professional and handles auto-fill hints.
- Check the visual alignment and "professionalism" against the screenshot provided.
