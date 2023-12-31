import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  // List<VideoModel> _list = [VideoModel(title: "First video")];
  List<VideoModel> _list = [];

  // 업로드 버튼을 누르면 loading 상태로 변경 후, Firebase에 업로드하고, 그 후 새 데이터를 가지게 됨
  void uploadVideo() async {
    // timeline_view_model이 다시 loading state가 되도록 해줌
    state = const AsyncValue.loading();
    await Future.delayed(
      const Duration(seconds: 2),
    );
    final newVideo = VideoModel(
      title: "${DateTime.now()}",
      description: '',
      fileUrl: '',
      thumbnailUrl: '',
      creatorUid: '',
      creator: '',
      likes: 0,
      comments: 0,
      createdAt: 0,
    );
    _list = [..._list, newVideo];
    // AsyncNotifier 안에는 loading, error, data와 같은 async!!! 값들이 있기 때문에
    // 다음과 같이 State를 바꿔줘야 함
    state = AsyncValue.data(_list);
  }

  // Notifier는 build 메서드에서 PlaybackConfigModel만 반환하는데 반해
  // FutureOr는 Future 또는 Model을 반환함
  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(
      const Duration(seconds: 5),
    );
    // throw Exception("OMG! can't ferch.");
    return _list;
  }
}

// Provider는 TimelineViewModel Notifier를 Expose 해주고, 화면에 전달할 List<VideoModel> 데이터를 제공
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  // ViewModel을 초기화 해 줄 function을 반환해주면 됨
  () => TimelineViewModel(),
);
