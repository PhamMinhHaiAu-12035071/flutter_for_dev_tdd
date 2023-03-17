import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/domain_exception.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login.dart';

class LoginState extends Equatable {
  final String? email;
  final String? password;
  final DomainException? emailError;
  final DomainException? passwordError;
  final bool isFormValid;
  final bool isLoading;
  final DomainException? mainError;
  final String navigateTo;

  const LoginState({
    required this.email,
    required this.password,
    required this.emailError,
    required this.passwordError,
    required this.isFormValid,
    required this.isLoading,
    required this.mainError,
    required this.navigateTo,
  });

  factory LoginState.empty() => const LoginState(
        email: null,
        password: null,
        emailError: null,
        passwordError: null,
        isFormValid: false,
        isLoading: false,
        mainError: null,
        navigateTo: '',
      );

  LoginState copyWith({
    String? email,
    String? password,
    DomainException? emailError,
    DomainException? passwordError,
    bool? isFormValid,
    bool? isLoading,
    DomainException? mainError,
    String? navigateTo,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isFormValid: isFormValid ?? this.isFormValid,
      isLoading: isLoading ?? this.isLoading,
      mainError: mainError ?? this.mainError,
      navigateTo: navigateTo ?? this.navigateTo,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailError,
        passwordError,
        isFormValid,
        isLoading,
        mainError,
        navigateTo
      ];
}

class CubitLoginPresenter extends Cubit<LoginState> implements LoginPresenter {
  CubitLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  }) : super(LoginState.empty());

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  @override
  Future<void> auth() async {
    emit(state.copyWith(isLoading: true));
    try {
      /// credentials login
      final account = await authentication.auth(
        AuthenticationParams(
          email: state.email!,
          secret: state.password!,
        ),
      );

      /// save account in cache
      await saveCurrentAccount.save(AccountEntity(account.token));

      /// navigate to home page
      emit(state.copyWith(navigateTo: '/surveys', isLoading: false));
    } on DomainException catch (error) {
      emit(state.copyWith(mainError: error, isLoading: false));
    }
  }

  @override
  Stream<DomainException?> get emailError =>
      stream.map((state) => state.emailError);

  @override
  Stream<bool> get isFormValid => stream.map((state) => state.isFormValid);

  @override
  Stream<bool> get isLoading => stream.map((state) => state.isLoading);

  @override
  Stream<DomainException?> get mainError =>
      stream.map((state) => state.mainError);

  @override
  Stream<String?> get navigateTo => stream.map((state) => state.navigateTo);

  @override
  Stream<DomainException?> get passwordError =>
      stream.map((state) => state.passwordError);

  @override
  void validateEmail(String email) {
    emit(state.copyWith(
        email: email,
        emailError: validation.validate(field: 'email', value: email)));
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    emit(state.copyWith(
      password: password,
      passwordError: validation.validate(field: 'password', value: password),
    ));
    _validateForm();
  }

  void _validateForm() {
    emit(state.copyWith(
      isFormValid: state.emailError == null &&
          state.passwordError == null &&
          state.email != null &&
          state.password != null,
    ));
  }
}
