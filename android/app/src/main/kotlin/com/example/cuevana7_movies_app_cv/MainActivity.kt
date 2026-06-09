package com.example.cuevana7_movies_app_cv

import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.cuevana7_movies_app_cv/biometric"
        ).setMethodCallHandler { call, result ->
            if (call.method == "authenticate") {
                val reason = call.argument<String>("reason") ?: "Usa tu huella"
                val biometricManager = BiometricManager.from(this)
                when (biometricManager.canAuthenticate(
                    BiometricManager.Authenticators.BIOMETRIC_STRONG
                        or BiometricManager.Authenticators.BIOMETRIC_WEAK
                )) {
                    BiometricManager.BIOMETRIC_SUCCESS -> {
                        val promptInfo = BiometricPrompt.PromptInfo.Builder()
                            .setTitle("Iniciar sesión")
                            .setSubtitle(reason)
                            .setNegativeButtonText("Cancelar")
                            .setAllowedAuthenticators(
                                BiometricManager.Authenticators.BIOMETRIC_STRONG
                                    or BiometricManager.Authenticators.BIOMETRIC_WEAK
                            )
                            .build()

                        BiometricPrompt(
                            this,
                            ContextCompat.getMainExecutor(this),
                            object : BiometricPrompt.AuthenticationCallback() {
                                override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                                    result.success(true)
                                }

                                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                                    result.success(false)
                                }
                            }
                        ).authenticate(promptInfo)
                    }
                    BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> result.success(false)
                    BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> result.success(false)
                    BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> result.success(false)
                    BiometricManager.BIOMETRIC_ERROR_SECURITY_UPDATE_REQUIRED -> result.success(false)
                    BiometricManager.BIOMETRIC_ERROR_UNSUPPORTED -> result.success(false)
                    BiometricManager.BIOMETRIC_STATUS_UNKNOWN -> result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
