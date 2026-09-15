# Astra Celestial Portal — Login UI/UX Overhaul

I have transformed the authentication flow into a highly professional, astrology-themed "Celestial Portal" that matches your reference design exactly.

## 🌟 Visual & UI Enhancements

### 1. Cosmic Background System
- **Astrology Chart Integration**: The `assets/images/login-bg.png` asset is now anchored in the top-right corner with a soft "mystical" opacity.
- **Dynamic Atmosphere**: Implemented a custom `AuthBackground` that features:
  - Deep space color palette (`#0B0B13`).
  - Slowly drifting purple and gold orbs.
  - A deterministic star field with gentle twinkling animations.
  - A "bottom fog" radial gradient for depth.

### 2. High-Fidelity "Astra" Components
- **Typography**: Integrated `GoogleFonts` using **Cinzel** for headings (mystical/ancient feel), **Playfair Display** for the welcome message, and **Lato** for functional text.
- **Header Affordance**: A custom circular "Moon" icon with a golden glowing border.
- **Glassmorphism**: The login card uses a deep translucent color (`#161622` at 90% opacity) with a subtle border and heavy soft shadow to pop against the space background.

### 3. Specialized Input Fields
- **Mobile Astral Line**: The phone input now features:
  - Integration with `intl_phone_number_input` for worldwide support.
  - A custom black-translucent style with gold focus rings.
  - "SMS Gateway Active" status indicator.
- **Celestial Cipher (OTP)**:
  - Re-implemented the OTP field using `pinput` with **circular pin themes** to match the reference circles.
  - "Code Sent" status dot and golden focus animations.
  - Custom `ResendTimer` renamed to "Resend Cipher".

### 4. Astra Action Buttons
- **Primary Action**: A large, golden-gradient button ("Initiate Celestial Link" / "Verify & Enter Portal") with a glowing shadow.
- **Social Alignment**: Stylized "Apple" and "Google" buttons under the "OR ALIGN WITH" divider.

## 🛠 Technical Cleanup
- **Modernized Colors**: Migrated `withOpacity` to the new `withValues(alpha: ...)` API where possible for precision.
- **Refactored Components**: Updated `AuthScaffold`, `PhonePage`, `OtpPage`, and `ResendTimer` to use the new terminology and visual style.

## 🚀 Verification
- Ran `flutter analyze` to ensure new UI code is clean.
- Verified that the `assets/images/login-bg.png` path is correctly used.
- Confirmed `google_fonts` dependency is added and working.

The login experience is now a professional "Natal Journey" that sets a powerful first impression for your astrology app.
