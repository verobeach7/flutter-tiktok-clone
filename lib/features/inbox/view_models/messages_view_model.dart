import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  // 에러 발생을 보여주고 싶다면 sendMessage의 argument로 BuildContext context를 받아서
  // snackBar로 에러를 보여주면 됨
  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
      );
      await _repo.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);
