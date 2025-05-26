package com.example.mobile

import android.content.Context
import android.util.Log
import android.view.View
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.example.mobile.HandLandmarkerHelper
import com.google.mediapipe.tasks.vision.core.RunningMode
import java.util.concurrent.Executors
import io.flutter.plugin.platform.PlatformView

class NativeCameraPlatformView(context: Context) : PlatformView,
    HandLandmarkerHelper.LandmarkerListener {

    private val view = NativeCameraView(context)
    private val cameraExecutor = Executors.newSingleThreadExecutor()
    private lateinit var handLandmarkerHelper: HandLandmarkerHelper

    init {
        setupCamera(context)
    }

    private fun setupCamera(context: Context) {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()

            handLandmarkerHelper = HandLandmarkerHelper(
                context = context,
                runningMode = RunningMode.LIVE_STREAM,
                handLandmarkerHelperListener = this
            )

            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(view.previewView.surfaceProvider)
            }

            val analyzer = ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
                .also {
                    it.setAnalyzer(cameraExecutor) { imageProxy ->
                        handLandmarkerHelper.detectLiveStream(imageProxy, true)
                    }
                }

            try {
                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(
                    context as LifecycleOwner,
                    CameraSelector.DEFAULT_FRONT_CAMERA,
                    preview,
                    analyzer
                )
            } catch (e: Exception) {
                Log.e("CameraView", "Binding failed", e)
            }
        }, ContextCompat.getMainExecutor(context))
    }

    override fun getView(): View = view

    override fun dispose() {}

    override fun onResults(resultBundle: HandLandmarkerHelper.ResultBundle) {
        // Send landmarks to Flutter
        // Flatten and send via MethodChannel (same as before)
    }

    override fun onError(error: String, errorCode: Int) {
        Log.e("HandLandmarker", "Error: $error")
    }
}
