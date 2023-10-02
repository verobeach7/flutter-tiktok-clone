import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/widgets/user_info.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text(
                  "verobeach",
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.gear,
                      size: Sizes.size20,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/60215757?v=4"),
                      child: Text("verobeach"),
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "@verobeach7",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gaps.h5,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue.shade500,
                        ),
                      ],
                    ),
                    Gaps.v24,
                    SizedBox(
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const UserInfo(
                              counts: "37", countsType: "Followings"),
                          _verticalDivider(),
                          const UserInfo(
                              counts: "10.5M", countsType: "Followers"),
                          _verticalDivider(),
                          const UserInfo(counts: "194,3M", countsType: "Likes")
                        ],
                      ),
                    ),
                    Gaps.v14,
                    FractionallySizedBox(
                      widthFactor: 0.33,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Sizes.size4,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Follow",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Gaps.v14,
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size32,
                      ),
                      child: Text(
                        "All highlights and where to watch live matches on FIFA+ I wonder how it would look",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size12,
                        ),
                        Gaps.h4,
                        Text(
                          "https://nomadcoders.co",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v20,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: PersistentTabBar(),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              GridView.builder(
                // 물리적으로 스크롤을 막을 수 있는 방법
                physics: const NeverScrollableScrollPhysics(),
                // 키보드를 사용하지 않고 GridView를 drag할 때 키보드가 사라지게 하는 기능
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // column수
                  crossAxisSpacing: Sizes.size2, // column 사이 간격
                  mainAxisSpacing: Sizes.size1, // row 사이 간격
                  childAspectRatio: 9 / 12, // 각 아이템의 비율을 설정
                ),
                // FadeInImage에 사용자가 어떤 비율의 이미지를 올릴지 모르니 AspectRatio를 이용하여 비율을 변환해줌
                itemBuilder: (context, index) => Column(
                  children: [
                    // 이미지 모서리를 둥글게 만들기 위해 Container 위젯을 이용
                    AspectRatio(
                      aspectRatio: 9 / 12,
                      child: FadeInImage.assetNetwork(
                          // fit: 부모 요소에 어떻게 적용할지를 정해줄 수 있음
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpeg",
                          image:
                              "https://m.media-amazon.com/images/I/61FmwxvYuJL._AC_UF894,1000_QL80_.jpg"),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text("page two"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

VerticalDivider _verticalDivider() {
  return VerticalDivider(
    width: Sizes.size32,
    thickness: Sizes.size1,
    color: Colors.grey.shade400,
    indent: Sizes.size14,
    endIndent: Sizes.size14,
  );
}
