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
  String convertedTime = "";
  final stampDateTime = DateTime.fromMillisecondsSinceEpoch(
    timeStamp,
  );

  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final todayYear = today.year;
  final stampYear = stampDateTime.year;
  Duration diff = today.difference(stampDateTime);
  int diffDays = diff.inDays;
  // int diffHours = diff.inHours;
  bool isBeforeToday = today.isAfter(stampDateTime);

  if (!isBeforeToday) {
    final amOrPm = stampDateTime.hour >= 12 ? "PM" : "AM";

    final hour = (stampDateTime.hour % 12) == 0 ? 12 : stampDateTime.hour % 12;
    final minute = stampDateTime.minute < 10
        ? "0${stampDateTime.minute}"
        : "${stampDateTime.minute}";

    convertedTime = "$amOrPm $hour:$minute";
  } else if (isBeforeToday && diffDays == 0) {
    convertedTime = "어제";
  } else if (isBeforeToday && todayYear == stampYear) {
    // 날짜 보여주기
    final month = stampDateTime.month;
    final day = stampDateTime.day;

    convertedTime = "$month월 $day일";
  } else {
    final year = stampDateTime.year;

    convertedTime = "$year년";
  }
  return convertedTime;
}
