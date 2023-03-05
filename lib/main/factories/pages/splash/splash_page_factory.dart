import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/main/factories/pages/splash/splash_presenter_factory.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

Widget makeSplashPage() {
  final presenter = Get.put<SplashPresenter>(makeGetxSplashPresenter());
  return SplashPage(presenter: presenter);
}
