import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          title: const Text("discover"),
          // TabBar를 컨트롤러 없이 사용하면 에러 발생함. 가장 쉬운 해결 방법은 DefaultTabController 위젯으로 감싸줌.
          bottom: TabBar(
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
              ),
              isScrollable: true,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size16,
              ),
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              tabs: [
                for (var tab in tabs)
                  Tab(
                    text: tab,
                  )
              ]),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(
                Sizes.size8,
              ),
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // column수
                crossAxisSpacing: Sizes.size10, // column 사이 간격
                mainAxisSpacing: Sizes.size10, // row 사이 간격
                childAspectRatio: 9 / 16, // 각 아이템의 비율을 설정
              ),
              itemBuilder: (context, index) => Container(
                color: Colors.yellow,
                child: Center(
                  child: Text("$index"),
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
              )
          ],
        ),
      ),
    );
  }
}
