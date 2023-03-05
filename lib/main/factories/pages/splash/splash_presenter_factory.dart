import 'package:flutter_for_dev_tdd/main/factories/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';

SplashPresenter makeGetxSplashPresenter() {
  final loadCurrentAccount = makeLocalLoadCurrentAccount();
  return GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
}
