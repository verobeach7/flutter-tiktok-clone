import 'package:flutter/material.dart';

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
          floating: true, // 위로 스크롤하면 사라졌던 appBar를 다시 나타나게 해줌
          stretch: true, // appBar를 최대 높이보다 더 커지게 할 수도 있음
          pinned: true, // 아래로 스크롤해도 완전히 사라지지 않고 배경색과 타이틀을 보여줌
          snap: true, // 스크롤하는 순간 자석처럼 붙게 함, floating과 함께 사용 가능
          backgroundColor: Colors.teal,
          collapsedHeight: 80, // appBar의 최소 높이
          expandedHeight: 200, // appBar의 최대 높이
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground, // 늘어날 때 블러 효과
              StretchMode.fadeTitle, // 늘어날 때 자막을 사라지게 함
              StretchMode.zoomBackground // 늘어날 때 배경 확대
            ],
            background: Image.asset(
              "assets/images/placeholder.jpeg",
              fit: BoxFit.cover,
            ),
            title: const Text(
              "Hello",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          itemExtent: 100, // item의 height를 설정
        )
      ],
    );
  }
}
