import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = false;

  void toggleAutoMute() {
    autoMute = !autoMute;
    // ChangeNotifier는 notifyListeners 메소드가 호출되면 autoMute 값을 가지고 있는 모든 위젯에게 바뀐 값을 알려줌
    notifyListeners();
  }
}

// Global Variable 전역변수 -> 좋은 방법은 아님
final videoConfig = VideoConfig();
