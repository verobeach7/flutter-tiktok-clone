import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/widgets/chat_user_select_modal.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';

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

  final List<int> _items = [];

  final Duration _duration = const Duration(milliseconds: 500);

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

  void _onUserSelectPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ChatUserSelectModal(),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
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
  }

  void _onChatTap(int index) {
    // context.push("/chats/$index");
    context.pushNamed(
      ChatDetailScreen.routeName,
      pathParameters: {
        "chatId": "$index",
      },
    );
  }

  Widget _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/60215757?v=4"),
        child: Text(
          "희성",
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "혜미 ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text("Don't forget to make video"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: () => _onUserSelectPressed(),
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: ref.watch(chatRoomsIdsProvider).when(
            data: (chatRooms) {
              final chatRoomIds = chatRooms.map((e) => e.chatRoomId).toList();
              // print(chatRoomIds[1]);
              final numberOfChatRooms = chatRoomIds.length;
              // print(numberOfChatRooms);
              return ref
                  .read(chatRoomsInfoProvider(ChatRooms(
                      chatRoomIds: chatRoomIds,
                      numberOfChatRooms: numberOfChatRooms)))
                  .when(
                    data: (chatRooms) {
                      return Scrollbar(
                        controller: _scrollController,
                        child: AnimatedList(
                          key: _key,
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.size10,
                          ),
                          // itemBuilder는 아이템이 생길 때만 build함
                          itemBuilder: (context, index, animation) {
                            return FadeTransition(
                              key: UniqueKey(),
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: _makeTile(index),
                                // child: const Text("test"),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrack) => Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
            },
            error: (error, stackTrack) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
