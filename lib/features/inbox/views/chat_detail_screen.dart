import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

// view_model에 알려주기 위해 reference에 접근해야 함
// 이를 위해 ConsumerStatefulWidget으로 변경
class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  // nestedRoute는 '/'를 사용하지 않음
  static const String routeURL = ":chatId";

  final String chatId;
  final UserProfileModel otherUser;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.otherUser,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  String _message = "";
  bool _isMessage = false;
  Offset tapPosition = Offset.zero;

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

  void _onInitializeMessage() {
    setState(() {
      _message = "";
      _isMessage = false;
      _textEditingController.clear();
    });
  }

  void _onFirstMessageSubmitted(
    String text,
    String chatRoomId,
    bool isFirstMsg,
    UserProfileModel otherUser,
  ) {
    if (!_isMessage) return;
    ref.read(messagesProvider(chatRoomId).notifier).handleMessage(
          text: text,
          isFirstMsg: isFirstMsg,
          otherUser: otherUser,
        );
    _onInitializeMessage();
  }

  void _onMessageSubmitted(
    String text,
    String chatRoomId,
    bool isFirstMsg,
  ) {
    if (!_isMessage) return;
    // 1. sendMessage는 Future로 await을 사용해야 하지만 이를 사용하지 않고도 가능
    ref.read(messagesProvider(chatRoomId).notifier).handleMessage(
          text: text,
          isFirstMsg: isFirstMsg,
        );
    _onInitializeMessage();
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.removeListener(() {});
    _textEditingController.dispose();
    super.dispose();
  }

  void _goBackPressed() {
    context.pushReplacementNamed(ChatsScreen.routeName);

    /* Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ChatsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var end = const Offset(1.0, 0.0);
          var begin = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ); */
  }

  void getTapPosition(TapDownDetails tapDownPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      tapPosition = renderBox.globalToLocal(tapDownPosition.globalPosition);
    });
  }

  void showPopUpMenu(String chatRoomId, MessageModel message) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTRB(
          tapPosition.dx,
          tapPosition.dy,
          10,
          10,
        ),
        Rect.fromLTRB(
          100,
          100,
          overlay.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              FaIcon(FontAwesomeIcons.trashCan),
              Gaps.h10,
              Text('Delete'),
            ],
          ),
          onTap: () {
            ref
                .read(messagesProvider(chatRoomId).notifier)
                .deleteMessage(message);
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black87,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2. ref.watch를 사용하여 loading 중인지 확인
    final chatRoomId = widget.chatId;
    final otherUser = widget.otherUser;
    final isLoading = ref.watch(messagesProvider(chatRoomId)).isLoading;
    final isDark = isDarkMode(context);
    bool isFirstMsg = true;

    return Scaffold(
      backgroundColor: isDark ? null : Colors.grey.shade50,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            onPressed: _goBackPressed,
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
            ),
          ),
        ),
        backgroundColor: isDark ? null : Colors.grey.shade50,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: Sizes.size20 + Sizes.size2,
                foregroundImage: otherUser.hasAvatar
                    ? NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F${otherUser.uid}?alt=media",
                      )
                    : null,
                child: Text(
                  widget.otherUser.name,
                  style: const TextStyle(
                    fontSize: Sizes.size8,
                  ),
                ),
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
            widget.otherUser.name,
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
              ref.watch(chatProvider(chatRoomId)).when(
                    data: (data) {
                      if (data.isNotEmpty) isFirstMsg = false;
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (isMine) ...[
                                Text(
                                  convertEpochToMsgTime(message.createdAt),
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: Sizes.size12,
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                Gaps.h10,
                              ],
                              GestureDetector(
                                onTapDown: (position) =>
                                    getTapPosition(position),
                                onLongPress: isMine && !message.isDeleted
                                    ? () {
                                        final now = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        final timeStamp = message.createdAt;
                                        final diffMinutes =
                                            (now - timeStamp) / 1000 / 60;
                                        if (diffMinutes <= 2) {
                                          showPopUpMenu(chatRoomId, message);
                                        } else {
                                          showToast(
                                              "Delete only within the last 2 minutes.");
                                        }
                                      }
                                    : () {
                                        showToast("Delete only my message.");
                                      },
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    Sizes.size14,
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 270,
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
                                      bottomRight: Radius.circular(
                                          !isMine ? Sizes.size20 : Sizes.size5),
                                    ),
                                  ),
                                  child: Text(
                                    message.isDeleted
                                        ? "[ Deleted ]"
                                        : message.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: Sizes.size16,
                                    ),
                                  ),
                                ),
                              ),
                              if (!isMine) ...[
                                Gaps.h10,
                                Text(
                                  convertEpochToMsgTime(message.createdAt),
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: Sizes.size12,
                                    height: 1,
                                  ),
                                ),
                              ],
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
                                onSubmitted: (value) => isLoading
                                    ? null
                                    : isFirstMsg
                                        ? _onFirstMessageSubmitted(
                                            _message,
                                            chatRoomId,
                                            isFirstMsg,
                                            otherUser,
                                          )
                                        : _onMessageSubmitted(
                                            _message,
                                            chatRoomId,
                                            isFirstMsg,
                                          ),
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
                                  : isFirstMsg
                                      ? _onFirstMessageSubmitted(
                                          _message,
                                          chatRoomId,
                                          isFirstMsg,
                                          otherUser,
                                        )
                                      : _onMessageSubmitted(
                                          _message,
                                          chatRoomId,
                                          isFirstMsg,
                                        ),
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
