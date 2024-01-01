import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

// 로딩 여부, 오류 발생 여부 등 확인을 위해 AsyncNotifier 이용
// 공개할 데이터를 없으므로 <void> 설정
class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo(File video, BuildContext context, String title,
      String description) async {
    // uid를 parameter로 넘겨주기 위해 불러옴
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        // UploadTask를 Return받음
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        // metadata가 있다는 것은 업로드가 성공했다는 것. 즉, Step1 영상을 스토리지에 올리기 성공
        if (task.metadata != null) {
          print(task.ref);
          await _repository.saveVideo(
            VideoModel(
                title: title,
                description: description,
                fileUrl: await task.ref.getDownloadURL(),
                thumbnailUrl: "",
                creatorUid: user.uid,
                creator: userProfile.name,
                likes: 0,
                comments: 0,
                createdAt: DateTime.now().millisecondsSinceEpoch),
          );
          context.pushReplacement("/home");
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
