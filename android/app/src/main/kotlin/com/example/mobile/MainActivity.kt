package com.example.mobile

import android.os.Bundle
import android.util.Log
import com.google.mediapipe.tasks.vision.core.RunningMode
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.mobile.HandLandmarkerHelper

class MainActivity : FlutterActivity(), HandLandmarkerHelper.LandmarkerListener {

    private val CHANNEL = "hand_landmarks"
    private lateinit var methodChannel: MethodChannel
    private lateinit var handLandmarkerHelper: HandLandmarkerHelper

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startLandmarker" -> {
                    startLandmarker()
                    result.success(true)
                }
                "sendImage" -> {
                    // In a later step: receive image from Flutter
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        handLandmarkerHelper = HandLandmarkerHelper(
            context = this,
            runningMode = RunningMode.LIVE_STREAM,
            handLandmarkerHelperListener = this
        )

        flutterEngine
        .platformViewsController
        .registry
        .registerViewFactory("native-camera-view", NativeCameraViewFactory())
    }

    private fun startLandmarker() {
        Log.d("Landmarker", "Started")
        // If you plan to run detection here, you can move camera to native side
    }

    override fun onResults(resultBundle: HandLandmarkerHelper.ResultBundle) {
        val landmarks = resultBundle.results.flatMap { result ->
            result.landmarks().flatMap { hand ->
                hand.map { listOf(it.x(), it.y()) }.flatten()
            }
        }
        methodChannel.invokeMethod("onLandmarks", landmarks)
    }

    override fun onError(error: String, errorCode: Int) {
        Log.e("LandmarkerError", "$error ($errorCode)")
    }
    
    

}
