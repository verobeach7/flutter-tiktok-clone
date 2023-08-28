import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
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

class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/IMG_2181.MOV");

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
    setState(() {});
    // video가 끝나는 시점을 알려주기 위해서 다음 과정 필요
    // addListener가 영상이 바뀌는 시간, 길이, 끝나는 시간 등을 모두 알려줄 수 있음
    _videoPlayerController.addListener(_onVideoChange);
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
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
    } else {
      _videoPlayerController.play();
    }
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
          const Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: Colors.white,
                  size: Sizes.size52,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
