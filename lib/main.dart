import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  // 시스템 색상을 선택할 수 있음(시각, cellular, wifi, battery)
  // main에서만 사용 가능한 것이 아니라 원하는 어느 곳에서도 사용할 수 있음!!!
  // main에서 사용하면 default 값을 정해주는 것이 됨
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug 모드 표시를 제거해줌
      title: 'TikTok Clone',
      // themeMode: ThemeMode.light, // 기기 설정이 다크모드로 되어있어도 강제로 light모드로 실행
      // themeMode: ThemeMode.dark, // 기기 설정이 다크모드로 되어있어도 강제로 dark모드로 실행
      themeMode: ThemeMode.system, // 기기 설정에 따라 실행
      theme: ThemeData(
          textTheme: Typography.blackMountainView,
          brightness: Brightness
              .light, // 따로 TextStyle을 지정하지 않은 부분은 자동으로 light모드에서 잘 보이도록 설정해줌
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade50,
          ),
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            // selectionColor: Color(0xFFE9435A),
          ),
          splashColor: Colors.transparent, // 클릭 시 반짝이는 효과 끄기
          highlightColor: Colors.transparent, // long press 색상 효과 끄기
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
          )),
      darkTheme: ThemeData(
        textTheme: Typography.whiteMountainView,
        brightness:
            Brightness.dark, // 따로 TextStyle을 지정한 부분은 brightness로 자동 적용되지 않음
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
          // selectionColor: Color(0xFFE9435A),
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.white,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
