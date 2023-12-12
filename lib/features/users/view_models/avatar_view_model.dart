import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    // userRepo는 Firestore와 연결
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    // authRepo는 FirebaseAuth와 연결
    // 사용자id는 Unique Key이므로 프로필사진 파일명으로 사용
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(() async {
      // Storage에 사진 업로드
      await _repository.uploadAvatar(file, fileName);
      ref.read(usersProvider.notifier).onAvatarUpload();
    });
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
