import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/IMG_2181.MOV");
  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;

  bool _isEllipsis = true;

  // _videoPlayerController.addListener가 사용할 메소드를 따로 생성
  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  // 시간이 소요되므로 비동기 작업 필요 async-await
  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    // video가 끝나는 시점을 알려주기 위해서 다음 과정 필요
    // addListener가 영상이 바뀌는 시간, 길이, 끝나는 시간 등을 모두 알려줄 수 있음
    // _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      // lowerBound와 upperBound는 scale을 결정함
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  // dispose 시켜주지 않으면 리소스 낭비로 메모리가 부족해 뻗음
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // upperBound에서 lowerBound로 애니메이션 함
    } else {
      _videoPlayerController.play();
      _animationController.forward(); // lowerBound에서 upperBound로 애니메이션 함
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onToggleEllipsis() {
    setState(() {
      _isEllipsis = !_isEllipsis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            // videoPlayerController가 동영상을 불러왔는지를 확인하고 불러왔으면 VideoPlayer 위젯을 보여주고 위젯에다가 컨트롤러 자신을 넘김
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController, // 컨트롤러의 값을 추적
                  builder: (context, child) {
                    // builder는 값이 변할 때마다 함수를 실행
                    return Transform.scale(
                      scale: _animationController.value,
                      child:
                          child, // AnimatedBuilder의 child인 AnimatedOpacity를 넘겨받음
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "@verobeach7",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "This is the SEOUL trip!!!!!!!!!!! I wanna go there again. This is the SEOUL trip!!!!!!!!!!! I wanna go there again.",
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: _isEllipsis
                              ? TextOverflow.ellipsis
                              : TextOverflow.visible,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onToggleEllipsis,
                        child: Text(
                          _isEllipsis ? "See more" : "Close",
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/60215757?v=4"),
                  child: Text(
                    "verobeach7",
                    style: TextStyle(
                      fontSize: Sizes.size8,
                    ),
                  ),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidComment,
                  text: "33.0K",
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
