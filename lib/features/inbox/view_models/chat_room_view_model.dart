import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatRoomViewModel extends FamilyAsyncNotifier<UserProfileModel, String> {
  late final ChatsRepository _repo;
  late final UserProfileModel user;

  @override
  FutureOr<UserProfileModel> build(String userId) async {
    _repo = ref.read(chatsRepo);
    user = await _repo.getUser(userId: userId);
    return user;
  }
}

final chatRoomProvider =
    AsyncNotifierProvider.family<ChatRoomViewModel, UserProfileModel, String>(
  (ChatRoomViewModel.new),
);

final chatRoomsListProvider = StreamProvider.autoDispose<List<ChatRoomModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    final user = ref.read(authRepo).user;

    return db
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter("personA", isEqualTo: user!.uid),
            Filter("personB", isEqualTo: user.uid),
          ),
        )
        .orderBy("lastStamp", descending: true)
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
