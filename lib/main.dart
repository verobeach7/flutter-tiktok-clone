import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/notifications/notifications_provider.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  // 시스템 색상을 선택할 수 있음(시각, cellular, wifi, battery)
  // main에서만 사용 가능한 것이 아니라 원하는 어느 곳에서도 사용할 수 있음!!!
  // main에서 사용하면 default 값을 정해주는 것이 됨
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  // context.push로 이동시 url이 변경되기를 원하는 경우 다음과 같이 설정
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // SharedPreferences는 Future이므로 async-await 필요(main에서 하는 이유)
  // SharedPreferences 인스턴스를 만들어야 함
  final preferences = await SharedPreferences.getInstance();
  // PlaybackConfigRepository 인스턴스를 만들 때 preferences(SharedPreferences로 만든 인스턴스)를 넘겨줘야 함
  final repository = PlaybackConfigRepository(preferences);

  runApp(
    // 앱이 시작되기 전에 override하기 위한 장치
    ProviderScope(overrides: [
      // PlaybackConfigProvider에서 에러가 발생하기 전에 override해줌으로써 해결
      playbackConfigProvider.overrideWith(
        () => PlaybackConfigViewModel(repository),
      ),
    ], child: const TikTokApp()),
  );
}

// TikTokApp에서 routerProvider를 통해 watch
class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // S.load(const Locale("en"));
    ref.watch(notificationProvider);
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
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
      themeMode: ThemeMode.light, // 기기 설정에 따라 실행
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
    );
  }
}
