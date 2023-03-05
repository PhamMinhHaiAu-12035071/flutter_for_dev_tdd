import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/splash/splash_presenter.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final SplashScreenPresenter presenter;

  const SplashPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Builder(builder: (context) {
      presenter.navigateTo.listen((page) {
        if (page?.isNotEmpty == true) {
          Get.offAllNamed(page!);
        }
      });
      return Scaffold(
          appBar: AppBar(title: const Text('Fake')),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    });
  }
}
