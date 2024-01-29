import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class ChatRoomViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;
  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomViewModel, void>(
  () => ChatRoomViewModel(),
);

final chatRoomsIdsProvider = StreamProvider.autoDispose<List<ChatRoomModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    final user = ref.read(authRepo).user;

    return db
        .collection("users")
        .doc(user!.uid)
        .collection("chatRooms")
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => ChatRoomModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  },
);

class ChatRooms {
  final List<String> chatRoomIds;
  final int numberOfChatRooms;

  ChatRooms({required this.chatRoomIds, required this.numberOfChatRooms});
}

final chatRoomsInfoProvider =
    StreamProvider.autoDispose.family<List<ChatRoomModel>, ChatRooms>(
  (ref, chatRooms) {
    final db = FirebaseFirestore.instance;
    final chatRoomIds = chatRooms.chatRoomIds;
    final numberOfChatRooms = chatRooms.numberOfChatRooms;

    for (String chatRoomId in chatRoomIds) {}

    final chatRoomInfo =
        db.collection("chat_rooms").doc(chatRoomIds[1]).snapshots().map(
              (docSnapshot) => ChatRoomModel.fromJson(
                docSnapshot.data()!,
              ),
            );

    return db
        .collection("chat_rooms")
        .doc(chatRoomIds[1])
        .snapshots()
        .map(
          (docSnapshot) => ChatRoomModel.fromJson(
            docSnapshot.data()!,
          ),
        )
        .toList()
        .asStream();
  },
);
