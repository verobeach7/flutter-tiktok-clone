import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message, String chatRoomId) async {
    // 나중에 roomId는 받아와야 함(OfLTIgNl4ttNamHq6M1P)
    await _db.collection("chat_rooms").doc(chatRoomId).collection("texts").add(
          message.toJson(),
        );
    await _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .update({"lastText": message.text, "lastStamp": message.createdAt});
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
