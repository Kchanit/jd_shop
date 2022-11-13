import 'package:flutter/material.dart';
import 'package:jd_shop/main.dart';

void showSnackBar(String? text, {Color? backgroundColor}) {
  if (text == null) return;

  final snackBar = SnackBar(
    content: Text(
      text,
      selectionColor: Colors.white,
    ),
    backgroundColor: backgroundColor ?? Colors.red[900],
  );
  messageKey.currentState!.removeCurrentSnackBar();
  messageKey.currentState!.showSnackBar(snackBar);
}
