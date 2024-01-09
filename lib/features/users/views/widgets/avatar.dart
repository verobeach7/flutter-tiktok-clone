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
              foregroundImage: hasAvatar ? NetworkImage(
                  // &haha=${DateTime.now().toString()}을 붙여주는 이유
                  // NetworkImage는 한번 fetching하면 캐시하여 주소가 같으면 처음 fetching한 캐시데이터를 그대로 이용
                  // 유니크한 현재 시간을 넣어줌으로써 주소가 계속 변경되도록 함
                  "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F$uid?alt=media&token=50516d79-bed0-4402-bced-eb321179814c&haha=${DateTime.now().toString()}") : null,
              child: Text(name),
            ),
    );
  }
}
