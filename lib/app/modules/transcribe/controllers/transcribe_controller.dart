import 'dart:typed_data';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TranscribeController extends GetxController {
  Interpreter? interpreter;
  RxString prediction = ''.obs;
  List<String> labels = [];
  Uint8List modelBytes = Uint8List(0);

  RxList<Offset> handLandmarks = <Offset>[].obs;
  static const MethodChannel _channel = MethodChannel('hand_landmarks');

  bool isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeNativeLandmarker();
    initialize();
  }

  Future<void> _initializeNativeLandmarker() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onLandmarks') {
        List<dynamic> flatLandmarks = call.arguments;
        final landmarks = <Offset>[];
        for (int i = 0; i < flatLandmarks.length; i += 2) {
          landmarks.add(Offset(
            (flatLandmarks[i] as num).toDouble(),
            (flatLandmarks[i + 1] as num).toDouble(),
          ));
        }
        updateHandLandmarks(landmarks);

        // Optional: Run TFLite model with handLandmarks (if needed)
        if (interpreter != null) {
          runModelOnLandmarks(landmarks);
        }
      }
    });

    await _channel.invokeMethod('startLandmarker');
  }

  @override
  void onReady() {
    super.onReady();
    if (!isInitialized) {
      initialize();
      isInitialized = true;
    }
  }

  @override
  void onClose() {
    interpreter?.close();
    super.onClose();
  }

  Future<void> initialize() async {
    print('[TranscribeController] Initializing...');
    await loadLabels();
    await loadModel();
    print('[TranscribeController] Initialization complete');
  }

  Future<void> loadLabels() async {
    try {
      final labelData =
          await rootBundle.rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n').map((label) => label.trim()).toList();
    } catch (e) {
      print("Error loading labels: $e");
    }
  }

  Future<void> loadModel() async {
    try {
      if (interpreter == null) {
        final byteData =
            await rootBundle.rootBundle.load('assets/model.tflite');
        modelBytes = byteData.buffer.asUint8List();
        interpreter = Interpreter.fromBuffer(modelBytes);
        print("Model loaded.");
      }
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  void updateHandLandmarks(List<Offset> landmarks) {
    handLandmarks.value = landmarks;
  }

  /// Optional: Run your TFLite model using landmarks directly
  void runModelOnLandmarks(List<Offset> landmarks) {
    try {
      if (interpreter == null) return;

      // Example: Flatten landmark coordinates into 1D input tensor
      final input = List<double>.generate(
        landmarks.length * 2,
        (i) => i.isEven ? landmarks[i ~/ 2].dx : landmarks[i ~/ 2].dy,
      ).reshape([1, landmarks.length * 2]);

      // Prepare output buffer (based on your model’s output shape)
      final outputShape = interpreter!.getOutputTensor(0).shape;
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);

      interpreter!.run(input, output);

      // Post-process output
      final outputList = output[0].cast<double>();
      final maxVal = outputList.reduce((a, b) => a > b ? a : b);
      final predictedIndex = outputList.indexOf(maxVal);
      final confidence = (maxVal * 100).toStringAsFixed(2);

      prediction.value = '${labels[predictedIndex]} ($confidence%)';
      print("Prediction: ${prediction.value}");
    } catch (e) {
      print("Error in runModelOnLandmarks: $e");
    }
  }
}
