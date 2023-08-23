import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTab,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final Function onTab;

  @override
  Widget build(BuildContext context) {
    // Expanded: 터치 공간을 최대한 늘려주기 위해서 최대한 확장함
    return Expanded(
      child: GestureDetector(
        onTap: () => onTab(),
        // Container에 넣어줘야 확장이 가능, 색상을 부여하기 때문에 공간 확장이 가능
        child: Container(
          color: Colors.black,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  color: Colors.white,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
