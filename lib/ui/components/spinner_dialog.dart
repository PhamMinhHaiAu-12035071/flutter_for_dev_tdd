import 'package:flutter/material.dart';

Future<dynamic> showLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        children: <Widget>[
          Column(
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading', textAlign: TextAlign.center),
            ],
          ),
        ],
      );
    },
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
