import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/video_flash_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

// AnimationController를 사용하기 위해서 with SingleTickerProviderStateMixin 해줘야 함
class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;

  bool _isSelfieMode = false;

  bool _appActivated = false;

  // for iOS simulator, 핸드폰도 똑같이 막힘, 폰에서 할 때는 삭제
  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late double _maxZoomLevel, _minZoomLevel, _currentZoomLevel;

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

  @override
  void initState() {
    super.initState();

    // for iOS simulator, 핸드폰도 똑같이 막힘, 폰에서 할 때는 삭제
    // initPermissions();
    if (!_noCamera) {
      initPermissions();
    } else {
      _hasPermission = true;
    }

    WidgetsBinding.instance.addObserver(this);

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

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱을 처음 설치하고 권한을 물을 때 권한 창이 뜨는 것을 inactive state로 판단하게 되며
    // 이때 cameraController가 없는 상태이기 때문에 충돌이 발생함
    // 순서가 중요함!!!!!! 카메라가 없는 경우 초기화 된 것도 없기 때문에 초기화 여부 자체를 확인하려고 하면 안됨
    // 즉 _noCamera가 제일 먼저 와야함
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _appActivated = false;
      setState(() {});

      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
      setState(() {});
    }
  }

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
      // Android Emulator Error: 오디오랑 비디오를 함께 찍으면 재생 안되고 첫 프레임만 보여짐
      // 오디오를 제거하고 녹화하여 재생 가능하게 해결해야 함
      // enableAudio: false,
    );

    await _cameraController.initialize();

    // iOS만을 위한 것, 가끔 영상과 오디오 싱크가 맞지 않게 되는데 이를 해결해주는 메소드임
    await _cameraController.prepareForVideoRecording();

    // 기기의 카메라 플래시 모드 정보를 받아와서 초기화
    _flashMode = _cameraController.value.flashMode;

    _maxZoomLevel = await _cameraController.getMaxZoomLevel();
    _minZoomLevel = await _cameraController.getMinZoomLevel();
    _currentZoomLevel = _minZoomLevel;

    _appActivated = true;

    // didChangeAppLifecycleState(AppLifecycleState state)에서 initCamera를 호출할 때
    // async-await Future<void>를 이용해야 하는 것을 피하기 위해 initCamera 안에서 setState 사용
    setState(() {});
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

  Future<void> _startRecording(TapDownDetails _) async {
    // 이미 녹화 중이라면 아무것도 하지 않음
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    // 녹화 중이 아니라면 아무것도 하지 않음
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    // 아래 문제를 해결하기 위해서 마운트 되어있지 않으면 아무것도 하지 않음
    if (!mounted) return;

    initCamera();

    // async 환경에서 context를 사용하면 문제가 생김
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      // source: ImageSource.camera, // 기기의 기본 camera를 사용 가능, 시간제한/ui 등 custom 불가능
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _onVerticalDragUpdate(DragUpdateDetails details) async {
    final dy = details.delta.dy;
    if (dy < 0 && _currentZoomLevel >= _maxZoomLevel ||
        dy > 0 && _currentZoomLevel <= _minZoomLevel) {
      return;
    }

    if (dy < 0 && _currentZoomLevel < _maxZoomLevel) {
      _currentZoomLevel -= (dy / 100);
    }
    if (dy > 0 && _currentZoomLevel > _minZoomLevel) {
      _currentZoomLevel -= (dy / 100);
    }

    _currentZoomLevel = _currentZoomLevel.clamp(_minZoomLevel, _maxZoomLevel);
    await _cameraController.setZoomLevel(_currentZoomLevel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission
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
                  if (_appActivated &&
                      !_noCamera &&
                      _cameraController.value.isInitialized)
                    CameraPreview(_cameraController),
                  const Positioned(
                    top: Sizes.size32,
                    left: Sizes.size20,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
                  if (!_noCamera)
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
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          // onLongPressEnd: (details) => _stopRecording(),
                          onVerticalDragUpdate: _onVerticalDragUpdate,
                          onVerticalDragEnd: (details) => _stopRecording(),
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
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
