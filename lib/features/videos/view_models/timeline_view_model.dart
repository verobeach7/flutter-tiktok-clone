import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result = await _repository.fetchVideos(
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(
      lastItemCreatedAt: null,
    );
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    _list = [..._list, ...nextPage];
    state = AsyncValue.data(_list);
  }

  // video_timeline을 새로고침 할 때 실행할 method
  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

// Provider는 TimelineViewModel Notifier를 Expose 해주고, 화면에 전달할 List<VideoModel> 데이터를 제공
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  // ViewModel을 초기화 해 줄 function을 반환해주면 됨
  () => TimelineViewModel(),
);
