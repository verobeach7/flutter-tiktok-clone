import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Storage와 연결, reference로 작동(링크라고 보면 됨)
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
  Future<void> uploadAvatar(File file, String fileName) async {
    // ref = reference, Returns a reference to a relative path from this reference.
    // 1. 파일을 넣기 위한 공간을 만들고(자리 예약)
    final fileRef = _storage.ref().child("avatar/$fileName");
    // 2. 파일을 넣어주면 됨
    await fileRef.putFile(file);
    // final task = await fileRef.putFile(file);
    // task로 받아서 pause, resume, cancel 등 다양한 것을 할 수 있음(putFile->uploadTask->Task로 들어가보면 확인 가능)
  }

  // 특정한 한가지만 업데이트 하는 것이 아니라 Map형식으로 보내진 데이터면 무엇이든지 업데이트 할 수 있도록 구성
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // update bio method
  // update link method
}

final userRepo = Provider((ref) => UserRepository());
