import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorMessage(
    BuildContext context, String error) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error, textAlign: TextAlign.center),
      backgroundColor: Colors.red,
    ),
  );
}
