import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/transcribe/controllers/transcribe_controller.dart';

class TranscribeView extends GetView<TranscribeController> {
  const TranscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Stack(
                children: [
                  AndroidView(
                    viewType: 'native-camera-view',
                    layoutDirection: TextDirection.ltr,
                  ),
                  CustomPaint(
                    size: Size(width, height),
                    painter: HandLandmarksPainter(
                      landmarks: controller.handLandmarks,
                      containerSize: Size(width, height),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class HandLandmarksPainter extends CustomPainter {
  final List<Offset> landmarks;
  final Size containerSize;

  HandLandmarksPainter({
    required this.landmarks,
    required this.containerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (final point in landmarks) {
      final scaled = Offset(
        point.dx * containerSize.width,
        point.dy * containerSize.height,
      );
      canvas.drawCircle(scaled, 6.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    return oldDelegate.landmarks != landmarks;
  }
}
