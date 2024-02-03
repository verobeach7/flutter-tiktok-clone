import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class MessagesViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessagesRepo _repo;
  late final User? _user;

  @override
  FutureOr<void> build(String chatRoomId) {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text, String chatRoomId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: _user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(message, chatRoomId);
    });
  }

  // 에러 발생을 보여주고 싶다면 sendMessage의 argument로 BuildContext context를 받아서
  // snackBar로 에러를 보여주면 됨
  Future<void> handleMessage({
    required String text,
    required bool isFirstMsg,
    required String chatRoomId,
    UserProfileModel? otherUser,
  }) async {
    _user = ref.read(authRepo).user;
    if (!isFirstMsg) {
      sendMessage(text, chatRoomId);
    } else {
      chatRoomId = chatRoomId;
      final chatRoom = ChatRoomModel(
        chatRoomId: chatRoomId,
        personA: _user!.uid,
        personB: otherUser!.uid,
        lastStamp: DateTime.now().millisecondsSinceEpoch,
        lastText: text,
      );
      await _repo.createChatRoom(chatRoom);
      sendMessage(text, chatRoomId);
    }
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String>(
  () => MessagesViewModel(),
);

/* .autoDispose를 사용해야 하는 이유: riverpod은 flutter에 의존하지 않기 때문에
 위젯트리 내에 있지 않음. 위젯트리 밖에 존재하며 class로 전역변수로서 존재함.
 채팅방에서 나가면 즉시 dispose됨. 이걸 하지 않으면 채팅방을 나가도 계속해서 살아있기 때문에
 알림을 계속해서 받게 됨. */
final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("texts")
      .orderBy("createdAt")
      // snapshots을 하면 Stream을 Return함(내 Collection의 상태)
      .snapshots()
      // event는 collection의 변동 사항을 감지함
      .map(
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});
