import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

class VideoDetailController extends GetxController {
  VideoPlayerController? videoController;
  CameraController? cameraController;

  final isCameraOn = false.obs;
  final isVideoInitialized = false.obs;
  final isCameraInitialized = false.obs;
  final cameraError = RxnString();

  List<CameraDescription> cameras = [];
  int currentCameraIndex = 0;

  late String videoPath;
  final videoTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    videoPath = args?['videoPath'] ?? '';
    videoTitle.value = args?['videoTitle'] ?? 'Untitled';

    initializeVideo();
    initializeAvailableCameras();
  }

  Future<void> initializeVideo() async {
    isVideoInitialized.value = false;

    if (videoController != null && videoController!.value.isInitialized) {
      await videoController!.dispose();
    }

    videoController = VideoPlayerController.asset(videoPath);
    await videoController!.initialize();
    videoController!.setLooping(true);
    videoController!.play();

    isVideoInitialized.value = true;
  }

  Future<void> initializeAvailableCameras() async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      cameras = [];
      print("Error getting cameras: $e");
    }
  }

  Future<void> _initCameraAtIndex(int index) async {
    try {
      isCameraInitialized.value = false;
      cameraError.value = null;

      await cameraController?.dispose();
      cameraController = CameraController(
        cameras[index],
        ResolutionPreset.medium,
      );
      await cameraController!.initialize();

      isCameraInitialized.value = true;
      isCameraOn.value = true;
      currentCameraIndex = index;
    } catch (e) {
      cameraError.value = e.toString();
      isCameraOn.value = false;
      isCameraInitialized.value = false;
    }
  }

  Future<void> initializeCamera() async {
    if (cameras.isEmpty) await initializeAvailableCameras();
    if (cameras.isEmpty) return;

    await _initCameraAtIndex(currentCameraIndex);
  }

  Future<void> toggleCamera() async {
    if (isCameraOn.value) {
      await cameraController?.dispose();
      cameraController = null;
      isCameraOn.value = false;
      isCameraInitialized.value = false;
    } else {
      await initializeCamera();
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    int newIndex = (currentCameraIndex + 1) % cameras.length;
    await _initCameraAtIndex(newIndex);
  }

  @override
  void onClose() {
    videoController?.dispose();
    cameraController?.dispose();
    super.onClose();
  }
}
