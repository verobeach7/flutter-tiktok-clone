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
    return CustomScrollView(
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
            ],
          ),
        )
      ],
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
