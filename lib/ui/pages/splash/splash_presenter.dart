import 'package:get/get.dart';

abstract class SplashPresenter {
  RxnString get navigateTo;
  Future<void> checkAccount();
}
