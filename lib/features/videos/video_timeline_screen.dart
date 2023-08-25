import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ];

  void _onPageChanged(int page) {
    // print(page);
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      colors.addAll([
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.teal,
      ]);
    }
    // setState를 반드시 해줘야함
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // main_navigation_screen의 Scaffold 안의 Stack에 있으므로 별도의 Scaffold나 Stack이 필요 없음.
    return PageView.builder(
      // // page를 자석처럼 붙게 만들수도 있고, 원하는 만큼만 보여지게 한 후 멈추게 할 수도 있음.
      // pageSnapping: false,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: _itemCount, // 갱신된 _itemCount를 계속 가질 수 있도록 연결해줌
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
          child: Text(
            "Screen $index",
            style: const TextStyle(
              fontSize: 68,
            ),
          ),
        ),
      ),
    );
  }
}
