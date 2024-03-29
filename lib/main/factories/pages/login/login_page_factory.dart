import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/main/factories/pages/login/login.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

Widget makeGetxLoginPage() {
  final presenter = Get.put<LoginPresenter>(makeGetxLoginPresenter());
  return LoginPage(presenter: presenter);
}

Widget makeCubitLoginPage() {
  final presenter = makeCubitLoginPresenter();
  return LoginPage(presenter: presenter);
}
