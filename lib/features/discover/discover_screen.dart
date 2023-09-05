import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
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
                childAspectRatio: 9 / 20, // 각 아이템의 비율을 설정
              ),
              // FadeInImage에 사용자가 어떤 비율의 이미지를 올릴지 모르니 AspectRatio를 이용하여 비율을 변환해줌
              itemBuilder: (context, index) => Column(
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: FadeInImage.assetNetwork(
                        // fit: 부모 요소에 어떻게 적용할지를 정해줄 수 있음
                        fit: BoxFit.cover,
                        placeholder: "assets/images/placeholder.jpeg",
                        image:
                            "https://m.media-amazon.com/images/I/61FmwxvYuJL._AC_UF894,1000_QL80_.jpg"),
                  ),
                  Gaps.v10,
                  const Text(
                    "This is a very long caption for my tiktok that im upload just now currently.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gaps.v5,
                  // DefaultTextStyle을 사용하여 Text 자식 요소 모두에게 동일한 스타일을 적용 가능
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey.shade600,
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
                          color: Colors.grey.shade600,
                        ),
                        Gaps.h2,
                        const Text(
                          "2.0M",
                        )
                      ],
                    ),
                  )
                ],
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
