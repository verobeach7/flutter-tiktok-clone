import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  // 처음 빌드 될 때는 유저가 계정이 없으므로 .empty를 이용하여 ""로 초기화
  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  // 4. userCredential을 이용하여 모델을 만들어줌
  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created.");
    }
    //6. 처리되는 동안 loading 상태로 변경(유저가 너무 빠르게 프로필 페이지로 이동하여 보려고 하는 것을 방지)
    state = const AsyncValue.loading();
    // 5. 만들어진 모델을 state에 넣어줌
    final profile = UserProfileModel(
      bio: "undefined",
      link: "undefined",
      email: credential.user!.email ?? "anon@anon.com",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anon",
    );
    // 6. User Repository의 createProfile을 호출(Firestore에 저장하기 위해)
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
    () => UsersViewModel());
