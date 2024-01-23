import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_user_select_view_model.dart';

class UserSelectionModal extends ConsumerStatefulWidget {
  const UserSelectionModal({super.key});

  @override
  UserSelectionState createState() => UserSelectionState();
}

class UserSelectionState extends ConsumerState<UserSelectionModal> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ref.watch(chatUsersListProvider).when(
          data: (userList) {
            // print(userList.length);
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.8,
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.sm,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Sizes.size14,
                  ),
                ),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: const Text(
                      "대화상대 선택",
                    ),
                    actions: [
                      IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const FaIcon(FontAwesomeIcons.xmark),
                      ),
                    ],
                  ),
                  body: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) => ListTile(
                      minVerticalPadding: Sizes.size16,
                      leading: CircleAvatar(
                        radius: Sizes.size32,
                        foregroundImage: userList[index].hasAvatar
                            ? NetworkImage(
                                // &haha=${DateTime.now().toString()}을 붙여주는 이유
                                // NetworkImage는 한번 fetching하면 캐시하여 주소가 같으면 처음 fetching한 캐시데이터를 그대로 이용
                                // 유니크한 현재 시간을 넣어줌으로써 주소가 계속 변경되도록 함
                                "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F${userList[index].uid}?alt=media")
                            : null,
                      ),
                      title: Text(
                        userList[index].name,
                        style: const TextStyle(
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userList[index].bio,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
