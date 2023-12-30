import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FullScreenLoading(),
  );
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(MySnackBar(content));
}
