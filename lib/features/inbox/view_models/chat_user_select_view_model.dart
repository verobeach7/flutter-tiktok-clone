import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatUserSelectViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final ChatsRepository _repo;
  late final List<UserProfileModel> _users;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _repo = ref.read(chatsRepo);
    _users = await getUsers();
    return _users;
  }

  Future<List<UserProfileModel>> getUsers() async {
    final userId = ref.read(authRepo).user!.uid;
    final users = _repo.getUsers(userId: userId);
    return users;
  }
}

final chatUsersListProvider =
    AsyncNotifierProvider<ChatUserSelectViewModel, List<UserProfileModel>>(
  () => ChatUserSelectViewModel(),
);
