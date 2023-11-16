import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/dark_mode_config/dark_mode_config.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';
import 'package:tiktok_clone/features/videos/video_recording_screen.dart';
import 'package:tiktok_clone/features/videos/video_timeline_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxx", // fake item(for video post)
    "inbox",
    "profile",
  ];

  // The instance member '_tabs' can't be accessed in an initializer.
  // late를 이용하여 해결
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  bool _isTabDown = false;

  void _checkSelectedIndex() {
    if (_selectedIndex != _tabs.indexOf(widget.tab)) {
      _selectedIndex = _tabs.indexOf(widget.tab);
      setState(() {});
    }
  }

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  void _onPostVideoButtonTapDown() {
    setState(() {
      _isTabDown = true;
    });
  }

  void _onPostVideoButtonTapCancel() {
    setState(() {
      _isTabDown = false;
    });
  }

  void _onPostVideoButtonTapUp() {
    setState(() {
      _isTabDown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // web에서 url parameter를 이용하여 home, discover, inbox, profile로 이동하는 경우 바뀐 index를 인식하여 보여주는 위젯을 변경
    if (kIsWeb) _checkSelectedIndex();
    final isDark = darkModeConfig.value;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // 키보드가 올라올 때 body(video_timeline_screen>video_post)가 찌그러지는 것을 막아줌
      // user_profile_screen.dart의 scaffold가 main_navigation_screen.dart이므로 여기서 배경색을 결정해줘야함
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(
              username: "verobeach",
              tab: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.only(
          bottom: Sizes.size32,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Discover",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              SizedBox(
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: _onPostVideoButtonTap,
                  onTapDown: (TapDownDetails details) {
                    _onPostVideoButtonTapDown();
                  },
                  onTapUp: (TapUpDetails details) {
                    _onPostVideoButtonTapUp();
                  },
                  onTapCancel: _onPostVideoButtonTapCancel,
                  child: PostVideoButton(
                    isTabDown: _isTabDown,
                    // selectedIndex가 0이 아닐 때 true 반환하고 색을 전환
                    inverted: _selectedIndex != 0,
                  ),
                ),
              ),
              Gaps.h24,
              NavTab(
                text: "Inbox",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
