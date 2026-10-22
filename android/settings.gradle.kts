try {
    val pe = Class.forName("java.lang.ProcessEnvironment")
    val theEnvField = pe.getDeclaredField("theEnvironment")
    theEnvField.isAccessible = true
    val theEnv = theEnvField.get(null) as MutableMap<String, String>
    theEnv.remove("ANDROID_PREFS_ROOT")

    val theCaseInsensitiveEnvField = pe.getDeclaredField("theCaseInsensitiveEnvironment")
    theCaseInsensitiveEnvField.isAccessible = true
    val theCaseInsensitiveEnv = theCaseInsensitiveEnvField.get(null) as MutableMap<String, String>
    theCaseInsensitiveEnv.remove("ANDROID_PREFS_ROOT")
    
    println("Successfully removed ANDROID_PREFS_ROOT via reflection")
} catch (e: Exception) {
    println("Failed to modify env: $e")
}

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.6.0" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
}

include(":app")
