import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Apply Google Services only when a google-services.json is present (per flavor or
// at the module root) so the app still builds before Firebase is configured.
val hasGoogleServices = file("google-services.json").exists() ||
    listOf("dev", "staging", "prod").any { File(projectDir, "src/$it/google-services.json").exists() }
if (hasGoogleServices) {
    apply(plugin = "com.google.gms.google-services")
}

android {
    namespace = "com.talkacharya.astrologer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // required by flutter_local_notifications
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.talkacharya.astrologer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "TalkAcharya Astro Dev")
            resValue("string", "app_link_host", "dev.talkacharya.com")
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "TalkAcharya Astro Staging")
            resValue("string", "app_link_host", "dev.talkacharya.com")
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "TalkAcharya Astrologer")
            resValue("string", "app_link_host", "talkacharya.com")
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
    }

    buildTypes {
        release {
            // TODO: real release signing config before Play upload.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
