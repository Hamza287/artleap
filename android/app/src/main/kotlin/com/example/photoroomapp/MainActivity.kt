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

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }

        try {
            val info = packageManager.getPackageInfo(
                "com.XrDIgital.ImaginaryVerse",
                PackageManager.GET_SIGNING_CERTIFICATES
            )
            info.signingInfo?.apkContentsSigners?.forEach { signature ->
                val md = MessageDigest.getInstance("SHA-256")
                md.update(signature.toByteArray())
                val keyHash = Base64.encodeToString(md.digest(), Base64.DEFAULT)
                Log.d("KeyHash:", keyHash)
            }
        } catch (e: Exception) {
            Log.e("KeyHash:", "Error generating key hash", e)
        }
    }
}
