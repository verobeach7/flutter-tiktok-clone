import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/dark_mode_config/dark_mode_config.dart';
// import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

// Statefulwidget을 한 이유는 _notifications를 state하기 위함이었음
// StatelessWidget으로 변경한 후 ConsumerWidget으로 다시 변경하여 Refactoring
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Align(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          child: ListView(
            children: [
              ValueListenableBuilder(
                valueListenable: darkModeConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) {
                    darkModeConfig.value = !darkModeConfig.value;
                  },
                  title: const Text(
                    "Dark Mode",
                  ),
                  subtitle: const Text("The app turns dark mode on."),
                ),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    // .notifier를 통해 class의 메서드에 접근할 수 있음
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: const Text(
                  "Mute video",
                ),
                subtitle: const Text("Video will be muted by default."),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => ref
                    .read(playbackConfigProvider.notifier)
                    .setAutoplay(value),
                title: const Text(
                  "Autoplay",
                ),
                subtitle: const Text("Video will start playing automatically."),
              ),

              // SwitchListTile 사용을 추천!!!
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text(
                  "Enable notifications",
                ),
                subtitle: const Text("Enable notifications"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                checkColor: Colors.white,
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notifications"),
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                  );
                  if (kDebugMode) {
                    print(date);
                  }
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }
                  final booking = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                    // 배경색과 글씨색이 같아서 보이지 않는 부분들이 있음
                    // builder를 통해 해결
                    builder: (context, child) {
                      return Theme(
                          data: ThemeData(
                            appBarTheme: const AppBarTheme(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                          child: child!);
                    },
                  );
                  if (kDebugMode) {
                    print(booking);
                  }
                },
                title: const Text("What is your birthday"),
              ),
              ListTile(
                title: const Text("Log out (iOS)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoDialog(
                    // 새로운 화면을 Navigator 한 것
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Please don't go"),
                      actions: [
                        CupertinoDialogAction(
                          // 화면을 없애고 이전의 화면으로 돌아가기 위해서 pop 해주기
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            ref.read(authRepo).signOut();
                            context.go("/");
                          },
                          isDestructiveAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Log out (android)"),
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    // 새로운 화면을 Navigator 한 것
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const FaIcon(
                        FontAwesomeIcons.skull,
                      ),
                      title: const Text("Are you sure?"),
                      content: const Text("Please don't go"),
                      actions: [
                        IconButton(
                          // 화면을 없애고 이전의 화면으로 돌아가기 위해서 pop 해주기
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car),
                        ),
                        TextButton(
                          onPressed: () => ref.read(authRepo).signOut(),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Log out (iOS / Bottom)"),
                textColor: Colors.red,
                onTap: () {
                  // showCupertinoModalPopup은 Cupertino와 Material을 가리지 않고 잘 작동함
                  showCupertinoModalPopup(
                    // 새로운 화면을 Navigator 한 것
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text("Are you sure?"),
                      message: const Text("Please don't go~~~"),
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Not log out"),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Yes Plz"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const AboutListTile(),
            ],
          ),
        ),
      ),
    );
  }
}
