import 'package:flutter_for_dev_tdd/main/factories/pages/login/login.dart';
import 'package:flutter_for_dev_tdd/main/factories/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';

LoginPresenter makeGetxLoginPresenter() {
  final authentication = makeRemoteAuthentication();
  final validation = makeLoginValidation();
  final saveCurrentAccount = makeLocalSaveCurrentAccount();
  return GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount);
}

LoginPresenter makeCubitLoginPresenter() {
  final authentication = makeRemoteAuthentication();
  final validation = makeLoginValidation();
  final saveCurrentAccount = makeLocalSaveCurrentAccount();
  return CubitLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount);
}
