import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      /* action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ), */
      content: Text(
        (error as FirebaseException).message ?? "Something went wrong.",
      ),
    ),
  );
}

String convertEpochToTime(int timeStamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(
    timeStamp,
  );
  final amOrPm = dateTime.hour >= 12 ? "PM" : "AM";
  final hour = (dateTime.hour % 12) == 0 ? 12 : dateTime.hour % 12;
  final minute =
      dateTime.minute < 10 ? "0${dateTime.minute}" : "${dateTime.minute}";

  final String convertedTime = "$amOrPm $hour:$minute";

  return convertedTime;
}
