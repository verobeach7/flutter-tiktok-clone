import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false; // 댓글을 쓰고 있는 중인지 파악

  void _onCloseBtnPressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size를 여러군데서 사용할 때 반복해서 적지 않기 위해서 설정
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);
    final ScrollController scrollController = ScrollController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.75,
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.sm,
        ),
        // Scaffold에 borderRadius를 먹일 방법이 없으니 Container로 감싸서 이를 해결
        clipBehavior: Clip
            .hardEdge, // Scaffold 위젯이 Container 위젯 위에 놓여서 화면에 넘치니 hardEdge를 이용하여 상위 위젯에 맞게 잘라줌
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Sizes.size14,
          ),
        ),
        child: Scaffold(
          // null로 설정하면 main.dart의 appBarTheme에서 가져옴
          backgroundColor: isDark ? null : Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: isDark ? null : Colors.grey.shade50,
            automaticallyImplyLeading: false, // 뒤로가기 버튼을 없애줌
            title: const Text("22796 comments"),
            actions: [
              // appBar에 원하는 위젯들을 넣어줄 수 있음
              IconButton(
                onPressed: _onCloseBtnPressed,
                icon: const FaIcon(FontAwesomeIcons.xmark),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: _stopWriting,
            child: Stack(
              children: [
                Scrollbar(
                  controller: scrollController,
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      top: Sizes.size10,
                      bottom: Sizes.size96 + Sizes.size10,
                      left: Sizes.size16,
                      right: Sizes.size16,
                    ),
                    separatorBuilder: (context, index) => Gaps.v20,
                    itemCount: 10,
                    itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isDark ? Colors.grey.shade500 : null,
                          child: const Text("희성"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "verobeach7",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Gaps.v3,
                              const Text(
                                  "That's not it l've seen the same thing but also in a cave")
                            ],
                          ),
                        ),
                        Gaps.h10,
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size20,
                              color: Colors.grey.shade500,
                            ),
                            Text(
                              "52.2K",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: size.width,
                  child: BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size16,
                        vertical: Sizes.size10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade500,
                            foregroundColor: Colors.white,
                            child: const Text("희성"),
                          ),
                          Gaps.h10,
                          Expanded(
                            child: SizedBox(
                              height: Sizes.size44,
                              child: TextField(
                                onTap: _onStartWriting,
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Add comment...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.size12,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size12,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: Sizes.size14,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.at,
                                          color: isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.gift,
                                          color: isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.faceSmile,
                                          color: isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        if (_isWriting)
                                          GestureDetector(
                                            onTap: _stopWriting,
                                            child: FaIcon(
                                              FontAwesomeIcons.circleArrowUp,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
