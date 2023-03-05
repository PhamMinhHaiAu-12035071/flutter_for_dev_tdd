import 'package:get/get.dart';

abstract class SplashScreenPresenter {
  RxnString get navigateTo;
  Future<void> loadCurrentAccount();
}
