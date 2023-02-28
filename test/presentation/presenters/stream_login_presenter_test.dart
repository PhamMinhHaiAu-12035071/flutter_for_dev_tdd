import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late ValidationSpy validation;
  late StreamLoginPresenter sut;
  late String email;

  When mockValidationCall(String? response) => when(() => validation.validate(
      field: any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? response}) =>
      mockValidationCall(response).thenReturn(response);

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });
  tearDown(() {
    reset(validation);
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email errors if validation fails', () {
    mockValidation(response: 'error');
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
