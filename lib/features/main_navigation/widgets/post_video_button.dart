import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({
    super.key,
    required this.isTabDown,
    required this.inverted,
  });

  final bool isTabDown;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Positioned 위젯은 위치 이동 시 Stack의 영역을 벗어나면 clipping 됨
      // 이를 clipping하지 못하게 하기 위해서 다음을 사용
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 20,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: isTabDown ? 32 : 30,
            width: isTabDown ? 28 : 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: isTabDown ? 32 : 30,
            width: isTabDown ? 28 : 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: isTabDown ? 32 : 30,
          width: isTabDown ? 45 : 40,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          decoration: BoxDecoration(
            color: inverted ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(
              Sizes.size6,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: inverted ? Colors.white : Colors.black,
              size: 18,
            ),
          ),
        )
      ],
    );
  }
}
