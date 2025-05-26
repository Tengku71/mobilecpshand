import 'package:flutter/services.dart';

class HandLandmarkerFlutter {
  static const MethodChannel _channel =
      MethodChannel('hand_landmarker_channel');

  static void startListening(
      void Function(List<List<Map<String, double>>>) onLandmarks) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onLandmarks') {
        final dynamic landmarksRaw = call.arguments;
        if (landmarksRaw is List) {
          // landmarksRaw is List<List<Map>>
          final List<List<Map<String, double>>> landmarks =
              List<List<Map<String, double>>>.from(
            landmarksRaw.map(
              (hand) => List<Map<String, double>>.from(
                  hand.map((lm) => Map<String, double>.from(lm))),
            ),
          );
          onLandmarks(landmarks);
        }
      }
    });

    _channel.invokeMethod('startHandLandmarker');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopHandLandmarker');
  }
}
