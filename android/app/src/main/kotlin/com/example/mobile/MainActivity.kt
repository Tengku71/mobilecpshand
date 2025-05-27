package com.example.mobile

import android.graphics.*
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.camera.core.ImageProxy
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
import androidx.camera.view.PreviewView
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity(), LifecycleOwner {

    private val EVENT_CHANNEL = "hand_landmarker"
    private val METHOD_CHANNEL = "hand_landmarks" // or "hand_landmarker" - must match Flutter side

    private var eventSink: EventChannel.EventSink? = null
    private lateinit var cameraHelper: CameraXHelper
    private lateinit var handLandmarkerHelper: HandLandmarkerHelper
    private lateinit var previewView: PreviewView

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLandmarker" -> {
                    startMediaPipeDetection()
                    result.success("MediaPipe started")
                }
                "stopLandmarker" -> {
                    stopMediaPipe()
                    result.success("MediaPipe stopped")
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("native-camera-view", CameraPreviewFactory(this))
    }

    private fun startMediaPipeDetection() {
        previewView = PreviewView(this)

        handLandmarkerHelper = HandLandmarkerHelper(
            context = this,
            runningMode = com.google.mediapipe.tasks.vision.core.RunningMode.LIVE_STREAM,
            minHandDetectionConfidence = 0.5f,
            minHandTrackingConfidence = 0.5f,
            minHandPresenceConfidence = 0.5f,
            handLandmarkerListener = object : HandLandmarkerHelper.LandmarkerListener {
                override fun onResults(result: HandLandmarkerResult, inputHeight: Int, inputWidth: Int) {
                    val handsJson = buildHandsJson(result)
                    eventSink?.success(handsJson)
                }

                override fun onError(error: String, errorCode: Int) {
                    Log.e("MainActivity", "MediaPipe error: $error ($errorCode)")
                    eventSink?.error("MediaPipeError", error, errorCode)
                }
            }
        )

        cameraHelper = CameraXHelper(
            context = this,
            cameraFacing = CameraXHelper.CameraFacing.FRONT,
            frameListener = { imageProxy ->
                val bitmap = imageProxyToBitmap(imageProxy)
                handLandmarkerHelper.detectLiveStreamFrame(bitmap)
                imageProxy.close()
            }
        )
        cameraHelper.startCamera(previewView)
    }

    private fun stopMediaPipe() {
        cameraHelper.stopCamera()
        handLandmarkerHelper.close()
    }

    private fun buildHandsJson(result: HandLandmarkerResult): String {
        val json = JSONObject()
        val handsArray = JSONArray()

        for (handLandmarks in result.landmarks()) {
            val landmarksArray = JSONArray()
            for (landmark in handLandmarks) {
                val lm = JSONObject()
                lm.put("x", landmark.x())
                lm.put("y", landmark.y())
                lm.put("z", landmark.z())
                landmarksArray.put(lm)
            }
            handsArray.put(landmarksArray)
        }

        json.put("hands", handsArray)
        return json.toString()
    }

    private fun imageProxyToBitmap(imageProxy: ImageProxy): Bitmap {
        val yBuffer = imageProxy.planes[0].buffer
        val uBuffer = imageProxy.planes[1].buffer
        val vBuffer = imageProxy.planes[2].buffer

        val ySize = yBuffer.remaining()
        val uSize = uBuffer.remaining()
        val vSize = vBuffer.remaining()

        val nv21 = ByteArray(ySize + uSize + vSize)
        yBuffer.get(nv21, 0, ySize)
        vBuffer.get(nv21, ySize, vSize)
        uBuffer.get(nv21, ySize + vSize, uSize)

        val yuvImage = YuvImage(nv21, ImageFormat.NV21, imageProxy.width, imageProxy.height, null)
        val out = ByteArrayOutputStream()
        yuvImage.compressToJpeg(Rect(0, 0, imageProxy.width, imageProxy.height), 100, out)
        val imageBytes = out.toByteArray()
        return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
    }
}
