import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:mobile/app/modules/video_detail/controllers/video_detail_controller.dart';
import 'package:video_player/video_player.dart';

class VideoDetailView extends GetView<VideoDetailController> {
  const VideoDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.videoTitle.value)),
      ),
      body: Column(
        children: [
          Obx(() {
            if (!controller.isVideoInitialized.value) {
              return Container(
                height: 200,
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return _VideoPlayerWithControls(controller: controller);
          }),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.cameraError.value != null) {
                return Center(
                  child: Text(
                    "Camera Error:\n${controller.cameraError.value}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!controller.isCameraOn.value) {
                return const Center(child: Text("Camera Off"));
              }
              if (controller.cameraController == null ||
                  !controller.isCameraInitialized.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return CameraPreview(controller.cameraController!);
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (!controller.isCameraOn.value) {
          return FloatingActionButton(
            heroTag: 'toggleCamera',
            onPressed: controller.toggleCamera,
            child: const Icon(Icons.videocam),
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'toggleCamera',
                onPressed: controller.toggleCamera,
                child: const Icon(Icons.videocam_off),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'switchCamera',
                onPressed: controller.switchCamera,
                child: const Icon(Icons.cameraswitch),
              ),
            ],
          );
        }
      }),
    );
  }
}

// _VideoPlayerWithControls remains the same as you already built it

class _VideoPlayerWithControls extends StatefulWidget {
  final VideoDetailController controller;
  const _VideoPlayerWithControls({required this.controller, Key? key})
      : super(key: key);

  @override
  State<_VideoPlayerWithControls> createState() =>
      _VideoPlayerWithControlsState();
}

class _VideoPlayerWithControlsState extends State<_VideoPlayerWithControls> {
  bool _showControls = true;
  bool _showPauseIcon = false;
  Timer? _hideTimer;
  Timer? _pauseIconTimer;

  VideoPlayerController? get videoController =>
      widget.controller.videoController;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    videoController?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _showPauseIconTemporarily() {
    _pauseIconTimer?.cancel();
    setState(() {
      _showPauseIcon = true;
    });
    _pauseIconTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showPauseIcon = false;
        });
      }
    });
  }

  void _onTapVideo() {
    final vc = videoController;
    if (vc == null || !vc.value.isInitialized) return;

    final isPlaying = vc.value.isPlaying;

    if (isPlaying) {
      vc.pause();
      _showPauseIconTemporarily();
    } else {
      vc.play();
    }

    setState(() {
      _showControls = true;
    });

    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pauseIconTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vc = videoController;
    if (vc == null || !vc.value.isInitialized) {
      return Container(
        height: 200,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final duration = vc.value.duration;
    final position = vc.value.position;

    return GestureDetector(
      onTap: _onTapVideo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: vc.value.aspectRatio,
            child: VideoPlayer(vc),
          ),
          if (_showControls)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.white70,
                          min: 0,
                          max: duration.inMilliseconds.toDouble(),
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                          onChanged: (value) {
                            vc.seekTo(Duration(milliseconds: value.toInt()));
                          },
                          onChangeStart: (_) => _hideTimer?.cancel(),
                          onChangeEnd: (_) => _startHideTimer(),
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_showPauseIcon)
            Icon(
              vc.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 60,
              color: Colors.white.withOpacity(0.8),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = duration.inHours;

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
