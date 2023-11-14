import 'package:flutter/material.dart';

// rebuild 될 때마다 VideoConfigData를 사용하는 모든 화면이 새 데이터를 받게 됨
// 새로 받은 autoMute 값, 수정 메소드, 자식 위젯을 다른 모든 화면과 공유할 수 있게 됨
class VideoConfigData extends InheritedWidget {
  final bool autoMute;

  final void Function() toggleMuted;

  const VideoConfigData({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  });

  static VideoConfigData of(BuildContext context) {
    // VideoConfigData 타입의 InheritedWidget을 가져오라고 context에 명령
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

// StatefulWidget은 InheritedWidget인 VideoConfigData 위젯을 반환함
// VideoConfigData 위젯은 앱의 모든 화면에 데이터를 공유함
// 데이터를 StatefulWidget에서 InheritedWidget으로 전달하여 공유하게 함
// 또한 InheritedWidget에게 데이터를 수정할 수 있는 메서드도 전달함
class VideoConfig extends StatefulWidget {
  final Widget child;

  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  // toggleMuted가 실행되면 autoMute의 값이 변경되고 rebuild됨
  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  // rebuild되면 VideoConfigData를 반환함 -> InheritedWidget이 새로운 데이터와 함께 rebuild됨
  // autoMute 값, 수정 메소드, 자식 위젯을 모두 InheritedWidget에 보냄
  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      // main.dart에서 VideoConfig 위젯을 사용하면 자식 위젯인 MaterialApp.router 위젯이 widget.child에 들거가게 됨
      child: widget.child,
    );
  }
}
