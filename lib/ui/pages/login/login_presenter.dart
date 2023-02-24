abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
  void dispose();

  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool?> get isFormValidStream;
  Stream<bool?> get isLoadingStream;
  Stream<String?> get mainErrorStream;
}
