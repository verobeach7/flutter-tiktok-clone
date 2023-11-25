import 'package:flutter/material.dart';

class VideoFlashButton extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final VoidCallback onPressed;

  const VideoFlashButton({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: isSelected ? Colors.amber.shade200 : Colors.white,
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
    );
  }
}
