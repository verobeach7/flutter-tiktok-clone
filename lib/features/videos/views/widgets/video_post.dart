import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final VideoModel videoData;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.videoData,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/IMG_2181.MOV");
  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;

  bool _isMuted = false;

  bool _isEllipsis = true;

  void _onLikeTap() {
    // ref.read(videoPostProvider.notifier).likeVideo(videoId);
    // 위의 방법으로도 가능하나 argument를 사용하여 provider를 초기화 시킬 수 있음
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    _isMuted = ref.read(playbackConfigProvider).muted;
    _isPaused = !ref.read(playbackConfigProvider).autoplay;
    if (kIsWeb || _isMuted) {
      await _videoPlayerController.setVolume(0);
      _isMuted = true;
    }

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
    _animationController.dispose();
    super.dispose();
  }

  /*  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    // _isMuted = false; // 나중에 수정 필요
    final muted = ref.read(PlaybackConfigProvider).muted;
    ref.read(PlaybackConfigProvider.notifier).setMuted(!muted);
    if (muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  } */

  void _onVisibilityChanged(VisibilityInfo info) {
    // 모든 stateful widget은 mounted라는 프로퍼티를 가지고 있음!
    // mounted 프로퍼티는 위젯이 mount되어 있는지를 알려줌.
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused && // 이 조건이 없으면 일시정지 상태에서 새로고침을 했을 때 Bug가 발생함
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (!mounted) return;
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

  void _onVolumeTap() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
    setState(() {});
  }

  void _onToggleEllipsis() {
    setState(() {
      _isEllipsis = !_isEllipsis;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 기본 크기가 아닌 내가 원하는 크기로 설정하고 싶은 경우 사용
      builder: (context) => const VideoComments(),
      // barrierColor: Colors.red,
      // backgroundColor: Colors.green, // 적용이 안 된 것처럼 보이는 이유는 위에 Scaffold 위젯이 놓여졌기 때문
      backgroundColor: Colors.transparent,
    );
    // print("close"); // async-await을 사용하여 댓글창이 열렸다가 닫히게 되는 시점을 알 수 있음. 닫힌 후 무엇을 할 지 코딩할 수 있음
    _onTogglePause();
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
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
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
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: _onVolumeTap,
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: _isMuted
                    ? const FaIcon(
                        FontAwesomeIcons.volumeOff,
                        color: Colors.white,
                        size: Sizes.size14,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.volumeHigh,
                        color: Colors.white,
                        size: Sizes.size14,
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
                  Text(
                    "@${widget.videoData.creator}",
                    style: const TextStyle(
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
                          widget.videoData.description,
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
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F${widget.videoData.creatorUid}?alt=media"),
                  child: Text(
                    widget.videoData.creator,
                    style: const TextStyle(
                      fontSize: Sizes.size8,
                    ),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikeTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(widget.videoData.likes),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () =>
                      _onCommentsTap(context), // 함수가 매개변수를 받아야 할 때 이렇게 처리
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
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
