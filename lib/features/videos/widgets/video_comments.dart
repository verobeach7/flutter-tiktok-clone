import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  void _onCloseBtnPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Scaffold에 borderRadius를 먹일 방법이 없으니 Container로 감싸서 이를 해결
      clipBehavior: Clip
          .hardEdge, // Scaffold 위젯이 Container 위젯 위에 놓여서 화면에 넘치니 hardEdge를 이용하여 상위 위젯에 맞게 잘라줌
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size14,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          automaticallyImplyLeading: false, // 뒤로가기 버튼을 없애줌
          title: const Text("22796 comments"),
          actions: [
            // appBar에 원하는 위젯들을 넣어줄 수 있음
            IconButton(
              onPressed: _onCloseBtnPressed,
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Container(
            child: const Text("Im a comment"),
          ),
        ),
      ),
    );
  }
}
