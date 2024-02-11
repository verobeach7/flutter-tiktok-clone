import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class NotificationsProvider extends AsyncNotifier {
  // 1. db와 message 서비스 연결
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    _db.collection("users").doc(user!.uid).update({"token": token});
  }

  // notification 권한 설정 및 State에 따른 처리
  Future<void> initListeners() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("I just got a message and I'm in the foreground.");
      print(event.notification?.title);
    });
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      print(notification.data['screen']);
    });
    // Terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      print(notification.data['screen']);
    }
  }

  @override
  FutureOr build() async {
    // 2. token을 받아와서 user DB에 저장
    final token = await _messaging.getToken();
    // token이 없는 경우가 있을 수 있으니 return처리
    if (token == null) return;
    await updateToken(token);
    await initListeners();
    // 3. token이 바뀌는 경우를 대비하여 update처리
    _messaging.onTokenRefresh.listen(
      (newToken) async {
        await updateToken(newToken);
      },
    );
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
