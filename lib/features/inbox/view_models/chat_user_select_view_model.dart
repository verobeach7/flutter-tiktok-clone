import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatUserSelectViewModel
    extends FamilyAsyncNotifier<List<UserProfileModel>, List<ChatRoomModel>> {
  late final ChatsRepository _repo;
  late final List<UserProfileModel> _users;

  @override
  FutureOr<List<UserProfileModel>> build(List<ChatRoomModel> arg) async {
    final userId = ref.read(authRepo).user!.uid;
    _repo = ref.read(chatsRepo);
    _users = await _repo.getUsers(userId: userId);

    final List<String> inProgressChatUsersIdList = arg.map((chatRoom) {
      if (chatRoom.personA == userId) {
        return chatRoom.personB;
      } else {
        return chatRoom.personA;
      }
    }).toList();

    for (int i = 0; i < inProgressChatUsersIdList.length; i++) {
      _users.removeWhere(
          (eachUser) => eachUser.uid == inProgressChatUsersIdList[i]);
    }

    return _users;
  }
}

final chatUsersListProvider = AsyncNotifierProvider.family<
    ChatUserSelectViewModel, List<UserProfileModel>, List<ChatRoomModel>>(
  ChatUserSelectViewModel.new,
);
