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
            return userList.isNotEmpty
                ? Align(
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
                                      "https://firebasestorage.googleapis.com/v0/b/tiktok-verobeach7.appspot.com/o/avatar%2F${userList[index].uid}?alt=media")
                                  : null,
                              child: userList[index].hasAvatar
                                  ? null
                                  : Text(userList[index].name),
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
                  )
                : const Center(
                    child: Text("가입된 사용자가 없습니다."),
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
