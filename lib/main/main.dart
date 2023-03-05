import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/components/app.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

void main() {
  R.load(const Locale('en', 'US'));
  runApp(const App());
}
