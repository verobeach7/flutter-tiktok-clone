import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/stf_screen.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/nav_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of widgets 생성
  final screens = [
    // const Center(
    //   child: Text(
    //     "Home",
    //     style: TextStyle(fontSize: Sizes.size48),
    //   ),
    // ),
    // const Center(
    //   child: Text(
    //     "Discover",
    //     style: TextStyle(fontSize: Sizes.size48),
    //   ),
    // ),
    // Container(),
    // const Center(
    //   child: Text(
    //     "Inbox",
    //     style: TextStyle(fontSize: Sizes.size48),
    //   ),
    // ),
    // const Center(
    //   child: Text(
    //     "Profile",
    //     style: TextStyle(fontSize: Sizes.size48),
    //   ),
    // ),
    // StfScreen처럼 여러개의 동일한 위젯을 사용 시 하나의 위젯으로 착각을 함, key를 이용해서 각각의 위젯을 유니크하게 만들어줌.
    // 탭을 전환했다가 이전에 사용했던 탭으로 돌아가면 이전의 사용 기록이 모두 삭제되고 다시 화면이 빌드되는 문제점을 가지고 있음
    // 이전의 사용 기록을 그대로 유지하고 싶을 때에는 탭 전환 시 dispose되는 것이 문제가 됨.
    // 즉, 개발자가 어떤 목적(유지 또는 폐기)을 가졌는지에 따라 문제가 될 수도 안 될 수도 있음.
    StfScreen(key: GlobalKey()),
    StfScreen(key: GlobalKey()),
    Container(),
    StfScreen(key: GlobalKey()),
    StfScreen(key: GlobalKey()),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTab: () => _onTap(0),
              ),
              NavTab(
                text: "Discover",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTab: () => _onTap(1),
              ),
              NavTab(
                text: "Inbox",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTab: () => _onTap(3),
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTab: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
