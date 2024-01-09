import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/utils.dart';

// view_model에 알려주기 위해 reference에 접근해야 함
// 이를 위해 ConsumerStatefulWidget으로 변경
class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  // nestedRoute는 '/'를 사용하지 않음
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  String _message = "";
  bool _isMessage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // print(_scrollController.offset);
    });
    _textEditingController.addListener(() {});
  }

  void _onMessageChanged(String value) {
    setState(() {
      _message = _textEditingController.text;
      _isMessage = _textEditingController.text.isNotEmpty;
    });
  }

  void _onMessageSubmitted(String text) {
    if (!_isMessage) return;
    // 1. sendMessage는 Future로 await을 사용해야 하지만 이를 사용하지 않고도 가능
    ref.read(messagesProvider.notifier).sendMessage(text);
    setState(() {
      _message = "";
      _isMessage = false;
      _textEditingController.clear();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.removeListener(() {});
    _textEditingController.dispose();
    super.dispose();
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // 2. ref.watch를 사용하여 loading 중인지 확인
    final isLoading = ref.watch(messagesProvider).isLoading;
    final isDark = isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark ? null : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: Sizes.size20 + Sizes.size2,
                foregroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/60215757?v=4"),
                child: Text("희성"),
              ),
              Positioned(
                bottom: -1,
                right: -3,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "희성 (${widget.chatId})",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: isDark ? Colors.grey.shade200 : Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h28,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: isDark ? Colors.grey.shade200 : Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: GestureDetector(
          onTap: _onStopWriting,
          child: Stack(
            children: [
              ref.watch(chatProvider).when(
                    data: (data) {
                      return ListView.separated(
                        reverse: true,
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          left: Sizes.size14,
                          right: Sizes.size14,
                          top: Sizes.size20,
                          bottom: MediaQuery.of(context).padding.bottom +
                              Sizes.size96,
                        ),
                        itemBuilder: (context, index) {
                          final message = data[index];
                          final isMine =
                              message.userId == ref.watch(authRepo).user!.uid;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  Sizes.size14,
                                ),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(
                                        Sizes.size20,
                                      ),
                                      topRight: const Radius.circular(
                                        Sizes.size20,
                                      ),
                                      bottomLeft: Radius.circular(
                                        isMine ? Sizes.size20 : Sizes.size5,
                                      ),
                                      bottomRight: Radius.circular(!isMine
                                          ? Sizes.size20
                                          : Sizes.size5)),
                                ),
                                child: Text(
                                  message.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => Gaps.v10,
                        itemCount: data.length,
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
                  ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: BottomAppBar(
                  color: isDark ? null : Colors.grey.shade200,
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size14,
                      vertical: Sizes.size4,
                    ),
                    height: Sizes.size80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: 4,
                                bottom: 0,
                                child: CustomPaint(
                                  painter: ChatBubbleTriangle(isDark),
                                ),
                              ),
                              TextField(
                                controller: _textEditingController,
                                onChanged: (value) => _onMessageChanged(value),
                                onSubmitted: (value) =>
                                    _onMessageSubmitted(value),
                                // textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                minLines: 1,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size20,
                                    vertical: Sizes.size4,
                                  ),
                                  hintText: "Send a message...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Gaps.h10,
                                      FaIcon(
                                        FontAwesomeIcons.faceSmile,
                                        color: isDark ? null : Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gaps.h20,
                        CircleAvatar(
                          backgroundColor:
                              _isMessage ? Colors.blue : Colors.grey.shade300,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 2,
                            ),
                            child: IconButton(
                              // 3. isLoading을 사용하여 messageProvider가 진행 중인지 확인
                              onPressed: () => isLoading
                                  ? null
                                  : _onMessageSubmitted(_message),
                              icon: FaIcon(
                                _isMessage
                                    ? FontAwesomeIcons.solidPaperPlane
                                    : FontAwesomeIcons.paperPlane,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubbleTriangle extends CustomPainter {
  final bool isDark;

  ChatBubbleTriangle(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = isDark ? Colors.grey.shade800 : Colors.white;

    var path = Path();
    path.lineTo(-15, 0);
    path.lineTo(0, -15);
    path.lineTo(15, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
