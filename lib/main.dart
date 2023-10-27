import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';

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
    // S.load(const Locale("ko"));
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug 모드 표시를 제거해줌
      title: 'TikTok Clone',
      // Delegates: 일종의 번역 파일로 text를 이미 가지고 있는 위젯들은 flutter에서 미리 번역해 놓았음. 그걸 가져다 쓰는 것
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      // intl 폴더 내 intl_en, intl_ko 파일로 지원 언어를 확인함
      supportedLocales: const [
        Locale("en"),
        Locale("ko"),
      ],
      // themeMode: ThemeMode.light, // 기기 설정이 다크모드로 되어있어도 강제로 light모드로 실행
      // themeMode: ThemeMode.dark, // 기기 설정이 다크모드로 되어있어도 강제로 dark모드로 실행
      themeMode: ThemeMode.system, // 기기 설정에 따라 실행
      theme: ThemeData(
        useMaterial3: true,
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
          // 스크롤하여 올릴 때 appBar의 색상이 변하기 때문에 surfaceTintColor를 이용하여 어떤 색으로 변할지 설정
          surfaceTintColor: Colors.white,
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
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        textTheme: Typography.whiteMountainView,
        brightness:
            Brightness.dark, // 따로 TextStyle을 지정한 부분은 brightness로 자동 적용되지 않음
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
          // selectionColor: Color(0xFFE9435A),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade700,
          labelColor: Colors.white,
        ),
        /* iconTheme: IconThemeData(
          color: Colors.grey.shade900,
        ), */
      ),
      home: const SignUpScreen(),
    );
  }
}
