import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile method
  // Model을 method의 parameter로 넣어줌
  Future<void> createProfile(UserProfileModel profile) async {
    // 7. Firestore와 연결(dart 이해 못하므로 클래스를 json으로 변환하여 전달)
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // get profile method
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // update avatar method
  // update bio method
  // update link method
}

final userRepo = Provider((ref) => UserRepository());
