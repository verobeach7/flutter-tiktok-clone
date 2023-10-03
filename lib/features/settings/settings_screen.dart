import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          // Licenses를 보여주는 방법 1.
          ListTile(
            // showAboutDialog는 구현이 이미 되어있는 함수
            onTap: () => showAboutDialog(
                context: context,
                applicationVersion: "1.0",
                applicationLegalese:
                    "All rights reserved. Please don't copy me."),
            title: const Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("About this app......"),
          ),
          // Licenses를 보여주는 방법 2.
          // onTap: () => showAboutDialog에서 해줘야 하는 작업을 자동으로 해줌
          const AboutListTile(),
        ],
      ),
    );
  }
}
