import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          CupertinoSwitch(
            value: _notifications,
            onChanged: _onNotificationChanged,
          ),
          Switch(
            value: _notifications,
            onChanged: _onNotificationChanged,
          ),
          // iOS와 android를 구분하여 보여줌(Cupertino vs Material), 적응형 위젯
          Switch.adaptive(
              value: _notifications, onChanged: _onNotificationChanged),
          SwitchListTile(
            value: _notifications,
            onChanged: _onNotificationChanged,
            title: const Text(
              "Enable notifications",
            ),
          ),
          // SwitchListTile 사용을 추천!!!
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotificationChanged,
            title: const Text(
              "Enable notifications",
            ),
            subtitle: const Text("Enable notifications"),
          ),
          Checkbox(
            value: _notifications,
            onChanged: _onNotificationChanged,
          ),
          CheckboxListTile(
            activeColor: Colors.black,
            value: _notifications,
            onChanged: _onNotificationChanged,
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
              print(date);

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);

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
              print(booking);
            },
            title: const Text("What is your birthday"),
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}
