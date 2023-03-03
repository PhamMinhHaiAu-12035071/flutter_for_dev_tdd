import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading() async {
  return Get.dialog(
    SimpleDialog(
      children: <Widget>[
        Column(
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading', textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
