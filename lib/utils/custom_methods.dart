import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FullScreenLoading(),
  );
}

void showSnackBar(BuildContext context, String content,
    {bool isDanger = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    MySnackBar(
      content,
      backgroundColor: isDanger
          ? Colors.red
          : Theme.of(context).snackBarTheme.backgroundColor,
    ),
  );
}

// ! Generate Different date from now to a date
String differenceDate(DateTime now, DateTime createdAt) {
  final difference = now.difference(createdAt);

  if (difference.inDays > 365) {
    return "${difference.inDays / 365} tahun lalu";
  }
  if (difference.inDays > 30) {
    return "${difference.inDays / 30} bulan lalu";
  }
  if (difference.inDays > 7) {
    return "${difference.inDays / 7} minggu lalu";
  }
  if (difference.inDays > 0 && difference.inDays < 7) {
    return "${difference.inDays} hari lalu";
  }
  if (difference.inHours > 0) {
    return "${difference.inHours} jam lalu";
  }
  if (difference.inMinutes > 0) {
    return "${difference.inMinutes} menit lalu";
  }

  return "baru saja";
}
