import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile method
  // Model을 method의 parameter로 넣어줌
  Future<void> createProfile(UserProfileModel user) async {}
  // get profile method
  // update avatar method
  // update bio method
  // update link method
}

final userRepo = Provider((ref) => UserRepository());
