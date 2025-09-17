plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.qanon"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.qanon"
        // استعمل خاصية minSdk (وليس دالة minSdkVersion)
        // تقدر تخليها تتبع إعدادات Flutter:
        // minSdk = flutter.minSdkVersion.toInt()
        // أو ثبّت قيمة مناسبة (مثلاً 23 إذا عندك حِزم تتطلب 23):
        minSdk = flutter.minSdkVersion.toInt()
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // مبدئياً استخدم توقيع debug عشان flutter run --release يشتغل
            signingConfig = signingConfigs.getByName("debug")
            // لو بدك تقلّل الحجم لاحقاً:
            // isMinifyEnabled = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
}

flutter {
    source = "../.."
}
