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
}

final chatsRepo = Provider(
  (ref) => ChatsRepository(),
);
