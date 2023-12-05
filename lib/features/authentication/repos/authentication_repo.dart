import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 유저가 로그인했는지 아닌지를 파악하는 Repository
// 복잡하게 사용자 기기의 저장공간에서 쿠키, 토큰 등을 확인하고 그것이 유효한지를 확인하고 할 필요 없음
class AuthenticationRepository {
  // main.dart에서 Firebase를 초기화하면 바로 인스턴스를 사용할 수 있음
  // 즉, Firebase Authentication과 직접 소통할 수 있음
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // isLoggedIn은 user가 있는지 없는지를 확인
  bool get isLoggedIn => user != null;
  // Getter: 값을 넣어주면 Property처럼 사용 가능(Authentication().user)
  // FirebaseAuth에게 현재 로그인한 유저가 있는지 확인
  User? get user => _firebaseAuth.currentUser;
}

final authRepo = Provider((ref) => AuthenticationRepository());
