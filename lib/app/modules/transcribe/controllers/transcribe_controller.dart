import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TranscribeController extends GetxController {
  static const EventChannel _eventChannel = EventChannel('hand_landmarker');
  static const MethodChannel _methodChannel = MethodChannel('hand_landmarks');

  RxList<Offset> handLandmarks = <Offset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _listenToNativeLandmarks();
    startLandmarker();
  }

  void _listenToNativeLandmarks() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(event);
        final List<dynamic> hands = jsonData['hands'] ?? [];
        final List<Offset> landmarks = [];

        if (hands.isNotEmpty) {
          final firstHand = hands[0] as List<dynamic>;
          for (final lm in firstHand) {
            final x = (lm['x'] as num).toDouble();
            final y = (lm['y'] as num).toDouble();
            landmarks.add(Offset(x, y));
          }
        }

        handLandmarks.value = landmarks;
      } catch (e) {
        print('Error parsing landmarks JSON: $e');
      }
    });
  }

  Future<void> startLandmarker() async {
    try {
      final result = await _methodChannel.invokeMethod('startLandmarker');
      print('Landmarker started: $result');
    } on PlatformException catch (e) {
      print('Failed to start landmarker: ${e.message}');
    }
  }

  Future<void> stopLandmarker() async {
    try {
      final result = await _methodChannel.invokeMethod('stopLandmarker');
      print('Landmarker stopped: $result');
    } on PlatformException catch (e) {
      print('Failed to stop landmarker: ${e.message}');
    }
  }
}
