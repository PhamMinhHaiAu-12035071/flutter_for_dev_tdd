import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/strings/strings.dart';

class R {
  static Translations strings = EnUs();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        strings = EnUs();
        break;
      case 'pt_BR':
        strings = PtBr();
        break;
      default:
        strings = EnUs();
    }
  }
}
