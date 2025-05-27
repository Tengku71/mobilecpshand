package com.example.mobile

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker.HandLandmarkerOptions
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.framework.image.BitmapImageBuilder

class HandLandmarkerHelper(
    private val context: Context,
    private val runningMode: RunningMode = RunningMode.LIVE_STREAM,
    private val minHandDetectionConfidence: Float = 0.5f,
    private val minHandTrackingConfidence: Float = 0.5f,
    private val minHandPresenceConfidence: Float = 0.5f,
    private val handLandmarkerListener: LandmarkerListener
) {
    companion object {
        const val TAG = "HandLandmarkerHelper"
    }

    private var handLandmarker: HandLandmarker? = null

    fun initialize() {
        try {
            val baseOptions = BaseOptions.builder()
                .setModelAssetPath("hand_landmarker.task")
                .build()

            val options = HandLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(runningMode)
                .setMinHandDetectionConfidence(minHandDetectionConfidence)
                .setMinHandPresenceConfidence(minHandPresenceConfidence)
                .setMinTrackingConfidence(minHandTrackingConfidence)
                .build()

            handLandmarker = HandLandmarker.createFromOptions(context, options)
        } catch (e: Exception) {
            handLandmarkerListener.onError("Initialization failed: ${e.message}", -1)
        }
    }

    fun detectLiveStreamFrame(bitmap: Bitmap, timestamp: Long = System.currentTimeMillis()) {
        val image = BitmapImageBuilder(bitmap).build()
        try {
            val result = handLandmarker?.detect(image)
            result?.let {
                handLandmarkerListener.onResults(it, bitmap.height, bitmap.width)
            }
        } catch (e: Exception) {
            handLandmarkerListener.onError("Detection failed: ${e.message}", -1)
        }
    }

    fun close() {
        handLandmarker?.close()
        handLandmarker = null
    }

    interface LandmarkerListener {
        fun onResults(result: HandLandmarkerResult, inputHeight: Int, inputWidth: Int)
        fun onError(error: String, errorCode: Int)
    }
}
