import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils.dart';

// SignUpViewModel에서는 아무것도 Expose하지 않을 것
// 계정을 만들 때 로딩화면을 보여주고, 계정 생성을 트리거 하는 역할
class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  // 반환할 것이 없음
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    /* await _authRepo.signUp(form["email"], form["password"]);
    state = AsyncValue.data(null); */
    // guard는 에러가 있다면 에러를 state에 넣어주고 에러가 없으면 데이터를 state에 넣어줌
    state = await AsyncValue.guard(() async {
      // 1. 계정 생성을 위해 Authentication Repository를 호출
      final userCredential = await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      );
      // 3. Return받은 userCredential을 가지고 createProfile를 호출
      await users.createProfile(userCredential);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

// StateProvider: 밖에서 수정할 수 있는 value를 Expose하게 해줌
final signUpForm = StateProvider((ref) => {});

// SignUpViewModel을 보고 있을 Provider 필요
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
