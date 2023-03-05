import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccount loadCurrentAccount;
  late SplashPresenter sut;
  late String token;
  late AccountEntity account;

  When mockLoadCurrentAccountCall() => when(() => loadCurrentAccount.load());
  void mockLoadCurrentAccount({AccountEntity? account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    token = faker.guid.guid();
    account = AccountEntity(token);
    mockLoadCurrentAccount(account: account);
  });
  test('Should call LoadCurrentAccount', () async {
    sut.checkAccount();
    verify(() => loadCurrentAccount.load()).called(1);
  });
  test('Should go to surveys page on success', () async {
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
