import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    try {
      final resultedValues = await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        loadCurrentAccount.load(),
      ]);
      final account = resultedValues[1] as AccountEntity?;
      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }

  @override
  RxnString get navigateTo => _navigateTo;
}
