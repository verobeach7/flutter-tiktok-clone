import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<UserProfileModel>> getUsers({required String userId}) async {
    final querySnapshot = await _db
        .collection("users")
        // .orderBy("name")
        .where("uid", isNotEqualTo: userId)
        .limit(20)
        .get();
    return querySnapshot.docs
        .map(
          (doc) => UserProfileModel.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  Future<UserProfileModel> getUser({required String userId}) async {
    late final UserProfileModel otherUser;
    await _db.collection("users").doc(userId).get().then((value) {
      // print(value.exists);
      if (value.exists) {
        otherUser = UserProfileModel.fromJson(value.data()!);
      } else {
        otherUser = UserProfileModel.empty();
      }
    });
    return otherUser;
    /* return await _db.collection("users").doc(userId).get().then(
          (value) => UserProfileModel.fromJson(value.data()!),
        ); */
  }
}

final chatsRepo = Provider(
  (ref) => ChatsRepository(),
);
