# ---- Flutter ---------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
# Deferred components references Play Core classes we don't ship.
-dontwarn com.google.android.play.core.**

# ---- Razorpay (reflection + JS bridge) --------------------------------------
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/*
-keepclasseswithmembers class * {
    public void onPayment*(...);
}
# Google Pay SDK referenced by Razorpay but optional.
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# ---- flutter_local_notifications (Gson-serialised scheduled notifications) --
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature

# ---- Firebase / Crashlytics: readable stack traces --------------------------
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# ---- flutter_secure_storage (Tink) ------------------------------------------
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# ---- flutter_webrtc (voice calls): JNI-called classes must keep their names --
-keep class org.webrtc.** { *; }
-keep class com.cloudwebrtc.webrtc.** { *; }
-dontwarn org.webrtc.**

# ---- flutter_foreground_task (call keep-alive service) -----------------------
-keep class com.pravera.flutter_foreground_task.** { *; }
