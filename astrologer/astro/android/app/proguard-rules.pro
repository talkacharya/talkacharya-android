# Preserve generic signatures to prevent Gson TypeToken runtime failures
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod, InnerClasses

# Prevent obfuscation of Gson TypeToken and its subclasses
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Keep classes used by flutter_local_notifications that rely on serialization
-keep class com.dexterous.flutterlocalnotifications.** { *; }
