import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersrepository;
  late final AuthenticationRepository _authenticationRepository;

  // 처음 빌드 될 때는 유저가 계정이 없으므로 .empty를 이용하여 ""로 초기화
  @override
  FutureOr<UserProfileModel> build() async {
    _usersrepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    // authRepo의 유저ID를 가지고 Firestore에서 프로필 정보 가져오기
    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersrepository
          .findProfile(_authenticationRepository.user!.uid);
      // Firestore에는 json으로 존재하므로 이를 UserProfileModel로 변환해야함
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  // 4. userCredential을 이용하여 모델을 만들어줌
  Future<void> createProfile(UserCredential credential) async {
    final form = ref.read(signUpForm);

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
      // name: credential.user!.displayName ?? "Anon",
      name: credential.user!.displayName ?? form["name"],
      birthday: form["birthday"],
    );
    // 6. User Repository의 createProfile을 호출(Firestore에 저장하기 위해)
    await _usersrepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
    () => UsersViewModel());
