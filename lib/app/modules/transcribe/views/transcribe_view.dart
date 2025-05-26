import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/transcribe/controllers/transcribe_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class TranscribeView extends GetView<TranscribeController> {
  const TranscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) async {
          switch (index) {
            case 0:
              await _handleNavigation(Routes.HOME);
              break;
            case 1:
              // Stay here
              break;
            case 2:
              await _handleNavigation(Routes.PROFILE);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "PROFILE",
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final containerWidth = constraints.maxWidth;
                    final containerHeight = constraints.maxHeight;

                    return Stack(
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: AndroidView(
                                viewType: 'native-camera-view',
                                layoutDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ),
                        CustomPaint(
                          painter: HandLandmarksPainter(
                            landmarks: controller.handLandmarks,
                            containerSize:
                                Size(containerWidth, containerHeight),
                          ),
                          size: Size.infinite,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Obx(() => Text(
                      "Prediction: ${controller.prediction.value}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _handleNavigation(String route) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await Get.toNamed(route);
    } finally {
      Get.back(); // Close loading dialog
      Get.delete<TranscribeController>();
    }
  }
}

/// Custom painter to draw hand landmarks scaled to container size
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
      // Scale normalized coordinates (0-1) to container size
      final scaled = Offset(
        point.dx * containerSize.width,
        point.dy * containerSize.height,
      );
      canvas.drawCircle(scaled, 5.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    return oldDelegate.landmarks != landmarks;
  }
}
