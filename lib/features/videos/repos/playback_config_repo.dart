// 데이터를 디스크에 persist하고 디스크에서 데이터를 가져오는 일만 함
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  // key값으로 사용될 때 타이핑 오류를 방지하기 위해 static const로 상수 지정
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;

  PlaybackConfigRepository(this._preferences);

  // 1. 음소거 관련 데이터를 디스크에 저장하는 메소드
  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  // 2. 자동재생 관련 데이터를 디스크에 저장하는 메소드
  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  // 3. 데이터를 읽어오는 메소드
  bool isMuted() {
    // ?? false : null을 반환하는 경우 디스크에 저장된 것이 없는 것이므로 false로 간주함
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? false;
  }
}
