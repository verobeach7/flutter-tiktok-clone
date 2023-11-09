import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_flash_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

// AnimationController를 사용하기 위해서 with SingleTickerProviderStateMixin 해줘야 함
class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;

  bool _isSelfieMode = false;

  // Recording Animation
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 200,
    ),
  );
  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;
  late CameraController _cameraController;

  // 2. initialize cameras
  Future<void> initCamera() async {
    final cameras = await availableCameras();

    // 기기에 카메라가 없으면 종료
    if (cameras.isEmpty) {
      return;
    }

    // 사용할 카메라 컨트롤러에 연결
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    // 기기의 카메라 플래시 모드 정보를 받아와서 초기화
    _flashMode = _cameraController.value.flashMode;
  }

  // 1. Permissions of camera, microphone
  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    // Android는 거절하면 한번 더 묻고, iOS는 한번 거절하면 영구 거절됨-설정에서 바꿔줘야 함
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      if (!mounted) return;

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Permissions warning!"),
          content:
              const Text("Please, allow the permissions in your settings."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              isDestructiveAction: true,
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    // controller의 변화를 감지
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    // 애니메이션 상태를 파악
    _progressAnimationController.addStatusListener((status) {
      // controller가 애니메이션이 끝났을 때를 알려줌
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  // 토글 버튼을 사용하면 다시 카메라를 초기화해야함. Future 사용해야 함
  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  // 기기에서 카메라 플래시 모드를 변경 시 적용
  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  void _startRecording(TapDownDetails _) {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size80 + Sizes.size8,
                    right: Sizes.size10,
                    child: Column(
                      children: [
                        IconButton(
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                          ),
                        ),
                        Gaps.v10,
                        VideoFlashButton(
                          isSelected: _flashMode == FlashMode.off,
                          icon: Icons.flash_off_rounded,
                          onPressed: () => _setFlashMode(FlashMode.off),
                        ),
                        Gaps.v10,
                        VideoFlashButton(
                          isSelected: _flashMode == FlashMode.always,
                          icon: Icons.flash_on_rounded,
                          onPressed: () => _setFlashMode(FlashMode.always),
                        ),
                        Gaps.v10,
                        VideoFlashButton(
                          isSelected: _flashMode == FlashMode.auto,
                          icon: Icons.flash_auto_rounded,
                          onPressed: () => _setFlashMode(FlashMode.auto),
                        ),
                        Gaps.v10,
                        VideoFlashButton(
                          isSelected: _flashMode == FlashMode.torch,
                          icon: Icons.flashlight_on_rounded,
                          onPressed: () => _setFlashMode(FlashMode.torch),
                        ),
                        Gaps.v10,
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Sizes.size96,
                    child: GestureDetector(
                      onTapDown: _startRecording,
                      onTapUp: (details) => _stopRecording(),
                      onLongPressEnd: (details) => _stopRecording(),
                      child: ScaleTransition(
                        scale: _buttonAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Sizes.size80 + Sizes.size10,
                              height: Sizes.size80 + Sizes.size10,
                              child: CircularProgressIndicator(
                                color: Colors.red.shade400,
                                strokeWidth: Sizes.size6,
                                value: _progressAnimationController.value,
                              ),
                            ),
                            Container(
                              width: Sizes.size80,
                              height: Sizes.size80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
