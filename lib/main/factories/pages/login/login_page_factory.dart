import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/main/factories/pages/login/login.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_page.dart';

Widget makeLoginPage() {
  final streamLoginPresenter = makeLoginPresenter();
  return LoginPage(presenter: streamLoginPresenter);
}
