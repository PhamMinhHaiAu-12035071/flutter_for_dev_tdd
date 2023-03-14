import 'package:flutter_for_dev_tdd/utils/i18n/strings/strings.dart';

class EnUs implements Translations {
  @override
  String get addAccount => 'Add Account';

  @override
  String get msgRequiredField => 'Field is not empty';

  @override
  String get msgInvalidEmail => 'Invalid email';

  @override
  String get httpInvalidCredentials => 'Invalid credentials';

  @override
  String get httpUnexpected => 'Unexpected error. Try again later.';

  @override
  String get notFoundItems => 'Not found items';

  @override
  String get readFileFailed => 'Read file failed';

  @override
  String get writeFileFailed => 'Write file failed';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Password Confirmation';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get btnLogin => 'Login';

  @override
  String get btnSignUp => 'Sign Up';
}
