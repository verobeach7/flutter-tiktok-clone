import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
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

  void _onMessageSubmitted(String value) {
    if (!_isMessage) return;
    if (kDebugMode) {
      print("Submitted $value");
    }
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
          title: const Text(
            "희성",
            style: TextStyle(
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
              ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: Sizes.size14,
                  right: Sizes.size14,
                  top: Sizes.size20,
                  bottom: Sizes.size96 + Sizes.size20,
                ),
                itemBuilder: (context, index) {
                  // 내부에 변수를 만들어 사용하기 위해서 '=>'이 아닌 '{}' 사용
                  final isMine = index % 2 == 0;
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
                              bottomRight: Radius.circular(
                                  !isMine ? Sizes.size20 : Sizes.size5)),
                        ),
                        child: const Text(
                          "This is a message",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: 20,
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
                              onPressed: () => _onMessageSubmitted(_message),
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
