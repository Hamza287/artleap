package com.XrDIgital.ImaginaryVerse

import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import java.security.MessageDigest

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Enable edge-to-edge experience for Android 11+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }

        try {
            val info = packageManager.getPackageInfo(
                "com.XrDIgital.ImaginaryVerse", // Your package name
                PackageManager.GET_SIGNATURES
            )
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val keyHash = String(Base64.encode(md.digest(), Base64.DEFAULT))
                Log.d("KeyHash:", keyHash)
            }
        } catch (e: Exception) {
            Log.e("KeyHash:", "Error generating key hash", e)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register your custom NativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile", // factoryId used in Dart
            ListTileNativeAdFactory(layoutInflater) // The class you created
        )
    }

    override fun onDestroy() {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine!!, "listTile")
        super.onDestroy()
    }
}
