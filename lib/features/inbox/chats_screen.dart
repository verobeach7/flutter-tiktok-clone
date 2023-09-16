import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // key를 가지고 AnimatedListState에 접근 가능
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final ScrollController _scrollController = ScrollController();

  final List<int> _items = [];

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

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: const Duration(
          milliseconds: 500,
        ),
      );
      _items.add(_items.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: Scrollbar(
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
                child: ListTile(
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
