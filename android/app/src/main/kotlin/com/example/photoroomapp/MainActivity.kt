package com.XrDIgital.ImaginaryVerse

import io.flutter.embedding.android.FlutterActivity
import android.content.pm.PackageManager
import android.util.Base64
import android.util.Log
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {
    init {
        try {
            val info = packageManager.getPackageInfo(
                "com.XrDIgital.ImaginaryVerse", // Your package name
                android.content.pm.PackageManager.GET_SIGNATURES
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
}
