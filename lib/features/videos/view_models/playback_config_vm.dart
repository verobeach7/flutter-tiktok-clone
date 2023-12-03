import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

// ChangeNotifier의 역할: view에서 이벤트가 발생하면 데이터를 수정하고, 데이터가 수정되면 view에게 데이터가 변했다는 것을 알림
// Notifier는 Riverpod에서 온 것, <PlaybackConfigModel>의 형태로 노출시키라고 명령하는 것
// 즉, PlaybackConfigModel에는 listen하기를 원하는 데이터가 있어야함(muted, autoplay)
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    // State는 mutate 할 수 없기 때문에 완전히 새로운 State를 만들어 대체
    state = PlaybackConfigModel(muted: value, autoplay: state.autoplay);
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(muted: state.muted, autoplay: value);
  }

  // build 메서드는 화면이 보기를 원하는 데이터의 초기 상태를 반환해야 함
  // PlaybackConfigViewModel이 생성되면 build 메서드를 실행하고 이를 통해 초기 State를 가지게 됨!!!
  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
        muted: _repository.isMuted(), autoplay: _repository.isAutoplay());
  }
}

// PlaybackConfigProvider를 만들면서 이것은 NotifierProvider라는 것을 알림
// Type 2개를 넣어줘야 함
// 한 개는 expose하기를 원하는 Provider, 또 한 개는 Provider가 expose 할 데이터
// 즉, Provider는 데이터 변경 시 PlaybackConfigViewModel과 PlaybackConfigModel에 알려야 함
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  // PlaybackConfigViewModel을 만들 때 repository를 인수로 보내야 함
  // () => PlaybackConfigViewModel(),
  // But!!! repository는 main.dart의 main에서 await을 통해 만든 preferenceS를 이용하여 만들어짐
  // 여기서 아직 만들어지지 않은 repository를 사용할 수 없기에 일부러 UnimplementedError를 던져줌
  // 지금만 아래처럼 할 것이고 다음부터는 위에 올바른 방식으로 할 것임(오직 SharedPreferences에 접근하기 위한 것임)
  // 아래에서 반환되는 것을 SharedPreferences가 반환된 이후에 PlaybackConfigViewModel로 일종의 override를 할 것임
  () => throw UnimplementedError(),
);
