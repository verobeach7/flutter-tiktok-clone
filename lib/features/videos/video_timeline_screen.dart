import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();

  // 반복해서 사용되므로 선언 및 초기화
  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    // print(page);
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      // linear: 애니메이션 없음
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
    }
    // setState를 반드시 해줘야함
    setState(() {});
  }

  // video가 끝나면 다음 video로 넘어가게 해줘야 함
  void _onVideoFinished() {
    return;
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    // Future.delayed를 이용해 Future가 있는 것처럼 fake할 수 있음
    // 실제로는 API를 이용해 데이터를 받아오고 처리하면 됨
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    // main_navigation_screen의 Scaffold 안의 Stack에 있으므로 별도의 Scaffold나 Stack이 필요 없음.
    return RefreshIndicator(
      onRefresh: _onRefresh, // 반드시 Future<void>를 리턴 받아야 함.
      displacement: 50,
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      child: PageView.builder(
        // // page를 자석처럼 붙게 만들수도 있고, 원하는 만큼만 보여지게 한 후 멈추게 할 수도 있음.
        // pageSnapping: false,
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: _itemCount, // 갱신된 _itemCount를 계속 가질 수 있도록 연결해줌
        itemBuilder: (context, index) =>
            VideoPost(onVideoFinished: _onVideoFinished, index: index),
      ),
    );
  }
}
