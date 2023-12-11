import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends ConsumerWidget {
  final String name;

  const Avatar({
    super.key,
    required this.name,
  });

  Future<void> _onAvatarTap() async {
    // pickImage는 XFILE을 반환(cross file)
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40, // percentage임
      maxHeight: 150,
      maxWidth: 150,
    );
    // 유저가 파일 선택을 취소하는 경우 null일 수 있음. 확인 필요!
    if (xfile != null) {
      final file = File(xfile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _onAvatarTap,
      child: CircleAvatar(
        radius: 50,
        foregroundImage: const NetworkImage(
            "https://avatars.githubusercontent.com/u/60215757?v=4"),
        child: Text(name),
      ),
    );
  }
}