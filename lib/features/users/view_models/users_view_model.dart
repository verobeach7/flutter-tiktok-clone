import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  // 처음 빌드 될 때는 유저가 계정이 없으므로 .empty를 이용하여 ""로 초기화
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  // 4. userCredential을 이용하여 모델을 만들어줌
  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created.");
    }
    // 5. 만들어진 모델을 state에 넣어줌
    state = AsyncValue.data(
      UserProfileModel(
        bio: "undefined",
        link: "undefined",
        email: credential.user!.email ?? "anon@anon.com",
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anon",
      ),
    );
  }
}

final usersProvider = AsyncNotifierProvider(() => UsersViewModel());
