import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  // List를 사용하는 이유: 복사본 유지, Pagenation을 위해 List에 아이템을 추가하기 위해
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    // fetchVideos: db의 videos 컬렉션을 생성일 기준으로 내림차순 정렬
    final result = await _repository.fetchVideos();
    final newList = result.docs.map(
      // 각각의 video doc을 Map<String, dynamic>으로 변환
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );
    // Iterable 타입을 List 타입으로 변경
    _list = newList.toList();
    return _list;
  }
}

// Provider는 TimelineViewModel Notifier를 Expose 해주고, 화면에 전달할 List<VideoModel> 데이터를 제공
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  // ViewModel을 초기화 해 줄 function을 반환해주면 됨
  () => TimelineViewModel(),
);
