import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  // ViewModel은 데이터를 읽고 쓸 수 있어야 함
  final PlaybackConfigRepository _repository;

  // PlaybackConfigModel Class를 통해서 _model 인스턴스를 만들기 위해 late를 붙여줌
  // _model로 하여 private으로 만들어 줌 -> 공개하지 않음으로써 아무대서나 수정이 불가능
  // _model에 repository에서 값을 불러옴
  late final PlaybackConfigModel _model = PlaybackConfigModel(
      //Model에 설정해야할 값을 _repository에서 읽어와서 설정함
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay());

  // 이 class를 construct할 때 실행됨.
  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  // 데이터 수정 메소드를 view에게 공개
  void setMuted(bool value) {
    // 1. 내 repository에서 값을 디스크에 persist하게 저장함
    _repository.setMuted(value);
    // 2. Model을 수정함
    _model.muted = value;
    // 3. listen하고 있는 모든 위젯에게 알림
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
