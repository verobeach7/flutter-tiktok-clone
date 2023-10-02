import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/user_info.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
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
                      const UserInfo(counts: "37", countsType: "Followings"),
                      _verticalDivider(),
                      const UserInfo(counts: "10.5M", countsType: "Followers"),
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.3,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(
                      vertical: Sizes.size10,
                    ),
                    labelColor: Colors.black,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: Icon(Icons.grid_4x4_rounded),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: FaIcon(FontAwesomeIcons.heart),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // tabBarView는 넓이와 높이에 제한이 없어서 SizedBox로 감싼 후 넓이와 높이를 정해줘야 함
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      const Center(
                        // SliverGrid를 넣고 싶으나 이미 SliverToBoxAdapter 안에 있기 때문에 sliver를 중첩하여 사용할 수 없음
                        child: Text("page one"),
                      ),
                      Center(
                        // SliverGrid를 사용할 수 없기 때문에 GridView.builder를 사용해야 함. But 스크롤 문제가 발생함.
                        // 스크롤 할 수 있는 구역이 2개가 됨. 위쪽 구역이 화면에서 사라지면 다시 스크롤 할 수 있는 방법이 없음.
                        child: GridView.builder(
                          // 물리적으로 스크롤을 막을 수 있는 방법
                          physics: const NeverScrollableScrollPhysics(),
                          // 키보드를 사용하지 않고 GridView를 drag할 때 키보드가 사라지게 하는 기능
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,

                          padding: const EdgeInsets.all(
                            Sizes.size8,
                          ),
                          itemCount: 20,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // column수
                            crossAxisSpacing: Sizes.size10, // column 사이 간격
                            mainAxisSpacing: Sizes.size10, // row 사이 간격
                            childAspectRatio: 9 / 20, // 각 아이템의 비율을 설정
                          ),
                          // FadeInImage에 사용자가 어떤 비율의 이미지를 올릴지 모르니 AspectRatio를 이용하여 비율을 변환해줌
                          itemBuilder: (context, index) => Column(
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
                                      placeholder:
                                          "assets/images/placeholder.jpeg",
                                      image:
                                          "https://m.media-amazon.com/images/I/61FmwxvYuJL._AC_UF894,1000_QL80_.jpg"),
                                ),
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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
