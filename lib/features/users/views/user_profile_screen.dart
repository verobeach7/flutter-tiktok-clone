import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/views/widgets/user_info.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        // backgroundColor: isDark ? Colors.black : null,
                        title: Text(
                          data.name,
                        ),
                        actions: [
                          IconButton(
                            onPressed: _onGearPressed,
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
                            Gaps.v20,
                            // CircleAvatar를 별도로 분리해야함
                            // users_view_model에 별도의 uploadAvatar 메서드를 넣고싶을 것이나
                            // 거기에 넣으면 .loading 시 전체 화면을 다시 로드하게 됨
                            // 아바타를 별도의 위젯으로 만들어 별도의 view-model을 제공하는 것이 사용자경험이 좋음
                            /* CircleAvatar(
                              radius: 50,
                              foregroundImage: const NetworkImage(
                                  "https://avatars.githubusercontent.com/u/60215757?v=4"),
                              child: Text(data.name),
                            ), */
                            Avatar(
                                name: data.name,
                                hasAvatar: data.hasAvatar,
                                uid: data.uid),
                            Gaps.v20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "@${data.name}",
                                  style: const TextStyle(
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
                              height: Sizes.size52,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const UserInfo(
                                      counts: "37", countsType: "Followings"),
                                  _verticalDivider(),
                                  const UserInfo(
                                      counts: "10.5M", countsType: "Followers"),
                                  _verticalDivider(),
                                  const UserInfo(
                                      counts: "194.3M", countsType: "Likes")
                                ],
                              ),
                            ),
                            Gaps.v14,
                            SizedBox(
                              height: Sizes.size44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.size48,
                                      vertical: Sizes.size12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          Sizes.size2,
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
                                  Gaps.h4,
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                            Sizes.size2,
                                          ),
                                        ),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.youtube,
                                        size: Sizes.size20,
                                      ),
                                    ),
                                  ),
                                  Gaps.h4,
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                            Sizes.size2,
                                          ),
                                        ),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.caretDown,
                                        size: Sizes.size14,
                                      ),
                                    ),
                                  ),
                                ],
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              width > Breakpoints.lg ? 5 : 3, // column수
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
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: FadeInImage.assetNetwork(
                                        // fit: 부모 요소에 어떻게 적용할지를 정해줄 수 있음
                                        fit: BoxFit.cover,
                                        placeholder:
                                            "assets/images/placeholder.jpeg",
                                        image:
                                            "https://m.media-amazon.com/images/I/61FmwxvYuJL._AC_UF894,1000_QL80_.jpg"),
                                  ),
                                  const Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.play_arrow_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "4.1M",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Sizes.size12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
