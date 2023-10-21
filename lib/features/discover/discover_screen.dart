import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Initial Text");

  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isWriting = true;
    });
    print("Searching for $value");
  }

  void _onSearchSubmitted(String value) {
    print("Submitted $value");
  }

  void _deleteWriting() {
    setState(() {
      _textEditingController.clear();
      _isWriting = false;
    });
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.3,
          // CupertinoSearchTextField에는 커서의 색상을 바꿀 수 있는 속성이 없으나 main.dart에서 전체 TextField에 대한 속성을 설정해줄 수 있음
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: Sizes.size44,
                width: MediaQuery.of(context).size.width - 70,
                alignment: const Alignment(0, 0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.sm,
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    onTap: _onStartWriting,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    // autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.size6),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode(context)
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size20,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size14,
                          vertical: Sizes.size10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: Sizes.size20,
                              color: isDarkMode(context)
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade800,
                            ),
                          ],
                        ),
                      ),
                      hintText: "Search",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size14,
                          vertical: Sizes.size10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isWriting)
                              GestureDetector(
                                onTap: _deleteWriting,
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  size: Sizes.size20,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.sliders,
                color: Colors.grey.shade800,
              ),
            ],
          ),
          // TabBar를 컨트롤러 없이 사용하면 에러 발생함. 가장 쉬운 해결 방법은 DefaultTabController 위젯으로 감싸줌.
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory, // 클릭 시 잉크 효과 제거
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: GestureDetector(
          onTap: _stopWriting,
          child: TabBarView(
            children: [
              GridView.builder(
                // 키보드를 사용하지 않고 GridView를 drag할 때 키보드가 사라지게 하는 기능
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(
                  Sizes.size8,
                ),
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > Breakpoints.lg ? 5 : 2, // column수
                  crossAxisSpacing: Sizes.size10, // column 사이 간격
                  mainAxisSpacing: Sizes.size10, // row 사이 간격
                  childAspectRatio: 9 / 20, // 각 아이템의 비율을 설정
                ),
                // FadeInImage에 사용자가 어떤 비율의 이미지를 올릴지 모르니 AspectRatio를 이용하여 비율을 변환해줌
                itemBuilder: (context, index) => LayoutBuilder(
                  builder: (context, constraints) => Column(
                    children: [
                      // 이미지 모서리를 둥글게 만들기 위해 Container 위젯을 이용
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Sizes.size3,
                          ),
                        ),
                        // Container 위에 이미지가 overflow되기 때문에 적용이 안 된 것처럼 보임.
                        // clip.hardEdge를 이용하여 잘라줘야 함.
                        clipBehavior: Clip.hardEdge,
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: FadeInImage.assetNetwork(
                              // fit: 부모 요소에 어떻게 적용할지를 정해줄 수 있음
                              fit: BoxFit.cover,
                              placeholder: "assets/images/placeholder.jpeg",
                              image:
                                  "https://m.media-amazon.com/images/I/61FmwxvYuJL._AC_UF894,1000_QL80_.jpg"),
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        "${constraints.maxWidth} This is a very long caption for my tiktok that im upload just now currently.",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: Sizes.size16 + Sizes.size2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v5,
                      // DefaultTextStyle을 사용하여 Text 자식 요소 모두에게 동일한 스타일을 적용 가능
                      if (constraints.maxWidth < 193.8 ||
                          constraints.maxWidth > 250 ||
                          !kIsWeb)
                        DefaultTextStyle(
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(
                                    "https://avatars.githubusercontent.com/u/60215757?v=4"),
                              ),
                              Gaps.h4,
                              const Expanded(
                                child: Text(
                                  "My avatar is going to be very long.",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gaps.h4,
                              FaIcon(
                                FontAwesomeIcons.heart,
                                size: Sizes.size16,
                                color: isDarkMode(context)
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade600,
                              ),
                              Gaps.h2,
                              const Text(
                                "2.0M",
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // tabs.skip(1)은 리스트의 첫번째 항목을 건너띄게 함.
              for (var tab in tabs.skip(1))
                Center(
                  child: Text(
                    tab,
                    style: const TextStyle(
                      fontSize: Sizes.size28,
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
