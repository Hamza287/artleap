package com.XrDIgital.ImaginaryVerse

import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity :  FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge experience for Android 11+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }

        try {
            val info = packageManager.getPackageInfo(
                "com.XrDIgital.ImaginaryVerse", // Your package name
                PackageManager.GET_SIGNING_CERTIFICATES  // Use this for better compatibility
            )
            info.signingInfo?.apkContentsSigners?.forEach { signature ->  // Safe call on signingInfo
                val md = MessageDigest.getInstance("SHA-256")  // Use SHA-256 for better security
                md.update(signature.toByteArray())
                val keyHash = Base64.encodeToString(md.digest(), Base64.DEFAULT)  // Use encodeToString
                Log.d("KeyHash:", keyHash)
            }
        } catch (e: Exception) {
            Log.e("KeyHash:", "Error generating key hash", e)
        }
    }
}
