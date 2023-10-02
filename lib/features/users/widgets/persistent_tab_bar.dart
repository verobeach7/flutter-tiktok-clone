import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          unselectedLabelColor: Colors.grey,
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
    );
  }

  @override
  double get maxExtent => 46.6;

  @override
  double get minExtent => 46.6;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
