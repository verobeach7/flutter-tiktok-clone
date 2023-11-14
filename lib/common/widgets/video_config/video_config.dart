import 'package:flutter/material.dart';

class VideoConfig extends InheritedWidget {
  // Wrapping하여 VideoConfig를 사용하는 child 위젯을 받아옴
  const VideoConfig({
    super.key,
    required super.child,
  });

  final bool autoMute = false;

  static VideoConfig of(BuildContext context) {
    // VideoConfig 타입의 InheritedWidget을 가져오라고 context에 명령
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
