import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatRoom(ChatRoomModel chatRoom) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoom.chatRoomId)
        .set(chatRoom.toJson());
  }

  Future<void> sendMessage(MessageModel message, String chatRoomId) async {
    // 나중에 roomId는 받아와야 함(OfLTIgNl4ttNamHq6M1P)
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .add(message.toJson())
        .then(
          (value) async => await value.update(
            {"textId": value.id},
          ),
        );
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .update({"lastText": message.text, "lastStamp": message.createdAt});
  }

  Future<void> deleteMessage(String chatRoomId, String textId) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .doc(textId)
        .update({"isDeleted": true});
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
