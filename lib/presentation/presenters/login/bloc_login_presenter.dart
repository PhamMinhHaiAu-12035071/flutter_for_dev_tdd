import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final String mainError;
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
        mainError: '',
        navigateTo: '',
      );

  LoginState copyWith({
    String? email,
    String? password,
    DomainException? emailError,
    DomainException? passwordError,
    bool? isFormValid,
    bool? isLoading,
    String? mainError,
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

class BlocLoginPresenter extends Cubit<LoginState> implements LoginPresenter {
  BlocLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  }) : super(LoginState.empty());

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  @override
  Future<void> auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  Stream<DomainException?> get emailError =>
      stream.map((state) => state.emailError);

  @override
  Stream<bool> get isFormValid => stream.map((state) => state.isFormValid);

  @override
  // TODO: implement isLoading
  Stream<bool> get isLoading => throw UnimplementedError();

  @override
  // TODO: implement mainError
  Stream<DomainException?> get mainError => throw UnimplementedError();

  @override
  // TODO: implement navigateTo
  Stream<String?> get navigateTo => throw UnimplementedError();

  @override
  // TODO: implement passwordError
  Stream<DomainException?> get passwordError => throw UnimplementedError();

  @override
  void validateEmail(String email) {
    final emailError = validation.validate(field: 'email', value: email);
    emit(state.copyWith(email: email, emailError: emailError));
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    // TODO: implement validatePassword
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
