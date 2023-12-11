import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserInfo extends StatelessWidget {
  final String counts, countsType;

  const UserInfo({
    super.key,
    required this.counts,
    required this.countsType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          counts,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          countsType,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
