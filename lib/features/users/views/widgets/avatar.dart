import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.name,
    required this.uid,
    required this.hasAvatar,
  });

  // ConsumerWidget은 StatelessWidget이므로 ref를 바로 사용할 수 없음
  // WidgetRef를 build에서 받아와서 사용
  Future<void> _onAvatarTap(WidgetRef ref) async {
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
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // avatarProvider가 Loading 중인지 확인하기 위해 필요
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F$uid?alt=media")
                  : null,
              child: Text(name),
            ),
    );
  }
}
