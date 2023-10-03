import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      /* body: const Column(
        children: [
          CloseButton(), // 별도의 아이콘 없이도 X 버튼 위젯을 사용할 수 있음
        ],
      ), */
      /* body: ListWheelScrollView(
        // 휠로 이루어진 아이템 리스트뷰를 사용할 수 있음
        itemExtent: 200, // 아이템의 높이
        /* // 확대 기능
        useMagnifier: true,
        magnification: 1.5, */
        // diameterRatio: 3, // 휠이 얼마나 휘어져있는지 설정, 100으로 설정하면 평면이 됨
        offAxisFraction: 2, // 옆으로 휘어지게 할 수 있음
        children: [
          for (var x in [1, 2, 1, 1, 1, 1, 1, 1, 1])
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: const Text(
                  "Pick me",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size36,
                  ),
                ),
              ),
            ),
        ],
      ), */
      body: const Column(
        children: [
          CupertinoActivityIndicator(
            radius: 30,
          ),
          CircularProgressIndicator(),
          // 플랫폼(ios, android 등)에 따라 다르게 보여줌
          CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
