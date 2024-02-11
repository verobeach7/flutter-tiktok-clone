import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/widgets/chat_user_select_modal.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/utils.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  // key를 가지고 AnimatedListState에 접근 가능
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final ScrollController _scrollController = ScrollController();

  final List<int> _items = []; // 참고용

  List<ChatRoomModel> _list = [];

  final Duration _duration = const Duration(milliseconds: 500);

  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onUserSelectPressed(List<ChatRoomModel> chatRoomsList) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChatUserSelectModal(chatRoomsList: chatRoomsList),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _addItem() {
    /* if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    } */
  }

  /* void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  } */

  void _onChatTap(ChatRoomModel chatRoom, UserProfileModel otherUser) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      pathParameters: {
        "chatId": chatRoom.chatRoomId,
      },
      extra: otherUser,
    );
  }

  Widget _makeTile(int index, ChatRoomModel chatRoom) {
    final user = ref.read(authRepo).user;
    final otherUserId =
        user!.uid == chatRoom.personA ? chatRoom.personB : chatRoom.personA;

    return ref.watch(chatRoomProvider(otherUserId)).when(
          data: (otherUser) {
            return ListTile(
              // onLongPress: () => _deleteItem(index),
              onLongPress: () {},
              onTap: () => _onChatTap(chatRoom, otherUser),
              leading: CircleAvatar(
                radius: 30,
                foregroundImage: otherUser.hasAvatar
                    ? NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F$otherUserId?alt=media",
                      )
                    : null,
                child: Text(
                  otherUser.name,
                  style: const TextStyle(
                    fontSize: Sizes.size10,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    otherUser.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    convertEpochToTime(chatRoom.lastStamp),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Sizes.size12,
                    ),
                  ),
                ],
              ),
              subtitle: Text(chatRoom.lastText),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.0,
            ),
          ),
        );
  }

  void _goBackPressed() {
    context.go("/home");
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(chatRoomsListProvider).when(
          data: (chatRoomsList) {
            print("before: $_list");
            if (isFirst) {
              _list = chatRoomsList;
              print("true: $_list");
              isFirst = false;
            } else {
              print("false(_list): $_list");
              print("false(chatRoomsList): $chatRoomsList");
              _addItem();
            }

            return Scaffold(
              appBar: AppBar(
                leading: Center(
                  child: IconButton(
                    onPressed: _goBackPressed,
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                    ),
                  ),
                ),
                elevation: 0.3,
                title: const Text("Direct messages"),
                actions: [
                  IconButton(
                    onPressed: () => _onUserSelectPressed(chatRoomsList),
                    icon: const FaIcon(
                      FontAwesomeIcons.plus,
                    ),
                  ),
                ],
              ),
              body: chatRoomsList.isNotEmpty
                  ? Scrollbar(
                      controller: _scrollController,
                      child: AnimatedList(
                        key: _key,
                        initialItemCount: chatRoomsList.length,

                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                        ),
                        // itemBuilder는 아이템이 생길 때만 build함
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: _makeTile(index, chatRoomsList[index]),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "참여중인 대화방이 없습니다.",
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
