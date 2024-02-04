import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_user_select_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatUserSelectModal extends ConsumerStatefulWidget {
  final List<ChatRoomModel> chatRoomsList;

  const ChatUserSelectModal({
    super.key,
    required this.chatRoomsList,
  });

  @override
  ChatUserSelectState createState() => ChatUserSelectState();
}

class ChatUserSelectState extends ConsumerState<ChatUserSelectModal> {
  void _onUserTap(UserProfileModel otherUser) {
    final user = ref.read(authRepo).user!;

    Navigator.pop(context);
    context.pushNamed(
      ChatDetailScreen.routeName,
      pathParameters: {
        "chatId": "${user.uid}000${otherUser.uid}",
      },
      extra: otherUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool existChatRoom = widget.chatRoomsList.isNotEmpty;
    return ref.watch(chatUsersListProvider(widget.chatRoomsList)).when(
          data: (usersList) {
            return usersList.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.8,
                      constraints: const BoxConstraints(
                        maxWidth: Breakpoints.sm,
                      ),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size14,
                        ),
                      ),
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: const Text(
                            "대화상대 선택",
                          ),
                          actions: [
                            IconButton(
                              onPressed: Navigator.of(context).pop,
                              icon: const FaIcon(FontAwesomeIcons.xmark),
                            ),
                          ],
                        ),
                        body: ListView.builder(
                            itemCount: usersList.length,
                            itemBuilder: (context, index) {
                              final eachUser = usersList[index];
                              return GestureDetector(
                                onTap: () => _onUserTap(eachUser),
                                child: ListTile(
                                  minVerticalPadding: Sizes.size16,
                                  leading: CircleAvatar(
                                    radius: Sizes.size32,
                                    foregroundImage: eachUser.hasAvatar
                                        ? NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F${usersList[index].uid}?alt=media")
                                        : null,
                                    child: eachUser.hasAvatar
                                        ? null
                                        : Text(eachUser.name),
                                  ),
                                  title: Text(
                                    eachUser.name,
                                    style: const TextStyle(
                                      fontSize: Sizes.size18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    eachUser.bio,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.8,
                      constraints: const BoxConstraints(
                        maxWidth: Breakpoints.sm,
                      ),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size14,
                        ),
                      ),
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: const Text(
                            "대화상대 선택",
                          ),
                          actions: [
                            IconButton(
                              onPressed: Navigator.of(context).pop,
                              icon: const FaIcon(FontAwesomeIcons.xmark),
                            ),
                          ],
                        ),
                        body: Center(
                          child: existChatRoom
                              ? const Text(
                                  "No users available for chat.",
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                  ),
                                )
                              : const Text(
                                  "No registered users found.",
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
