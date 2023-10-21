import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  // Ticker를 주는 Mixin일 뿐만 아니라 위젯트리에 없을 때 리소스 낭비를 막아주는 역할도 함.
  final List<String> _notifications = List.generate(20, (index) => "${index}h");

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  bool _showBarrier = false;

  // this나 다른 instance member를 참조하려는 경우에도
  // dart, flutter에서는 late를 사용하는 경우에도 초기화를 함께할 수 있음.
  // 반드시 initState를 사용하지 않아도 됨.
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

/*   @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  } */

  // _animationController와 _animation을 연결
  // Tween을 사용하는 경우에는 Animation의 Type을 반드시 설정해줘야 함.
  // setState, eventListener, animation builder를 사용하지 않아도 애니메이션을 만들 수 있음.<추천>
  late final Animation<double> _arrowAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  // Offset은 비율임. 0.5 = 50%
  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(_animationController);

  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  void _onDismissed(String notification) {
    // 위젯 트리에서 삭제한 후 setState를 통해 다시 build
    _notifications.remove(notification);
    setState(() {});
  }

  void _onToggleAnimations() async {
    if (_animationController.isAnimating) return;
    if (_animationController.isCompleted) {
      // animationController.forward와 .reverse는 TickerFuture이기 때문에 await을 이용하여 애니메이션이 완료되기까지 기다리게 할 수 있음
      await _animationController.reverse();
    } else {
      _animationController.forward();
    }

    // Barrier가 보여지는 상황인지 보이지 않는 상황인지에 따라 위젯을 보이게 또는 보이지 않게 할 수 있음
    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    // print(_notifications); // _notifications List 변화를 확인해볼 수 있음
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: _onToggleAnimations,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("All activity"),
              Gaps.h2,
              RotationTransition(
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Gaps.v14,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size12,
                ),
                child: Text(
                  "New",
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Gaps.v14,
              for (var notification in _notifications)
                Dismissible(
                  key: Key(notification),
                  onDismissed: (direction) => _onDismissed(notification),
                  background: Container(
                    alignment:
                        Alignment.centerLeft, // Container 내부의 위젯들을 정렬하는데 사용
                    color: Colors.green,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment:
                        Alignment.centerRight, // Container 내부의 위젯들을 정렬하는데 사용
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        right: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  child: ListTile(
                    minVerticalPadding: Sizes.size16,
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade400,
                            width: Sizes.size1,
                          )),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                        ),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: "Account updates:",
                        style: TextStyle(
                          color: isDark ? null : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size16,
                        ),
                        children: [
                          const TextSpan(
                            text: " Upload longer videos",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: " $notification",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size16,
                    ),
                  ),
                ),
            ],
          ),
          if (_showBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              dismissible: true,
              onDismiss: _onToggleAnimations,
            ),
          SlideTransition(
            position: _panelAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    Sizes.size5,
                  ),
                  bottomRight: Radius.circular(
                    Sizes.size5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab["icon"],
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
