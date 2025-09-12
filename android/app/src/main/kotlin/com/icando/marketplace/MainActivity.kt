package com.icando.marketplace

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private lateinit var backCallback: OnBackPressedCallback

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        backCallback = object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                // Allow Flutter to process the back press
                isEnabled = false
                onBackPressedDispatcher.onBackPressed()
                isEnabled = true
            }
        }
    }

    override fun onStart() {
        super.onStart()
        onBackPressedDispatcher.addCallback(this, backCallback)
    }

    override fun onStop() {
        backCallback.remove()
        super.onStop()
    }

    override fun onDestroy() {
        // Ensure the callback is detached to avoid "sendCancelIfRunning" warnings
        if (this::backCallback.isInitialized) {
            backCallback.remove()
        }
        super.onDestroy()
    }
}