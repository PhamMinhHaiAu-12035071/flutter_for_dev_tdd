import 'package:flutter_for_dev_tdd/utils/i18n/strings/strings.dart';

class PtBr implements Translations {
  @override
  String get addAccount => 'Criar Conta';

  @override
  String get msgRequiredField => 'Campo obrigatório';

  @override
  String get msgInvalidEmail => 'Email inválido';

  @override
  String get httpInvalidCredentials => 'Credenciais inválidas';

  @override
  String get httpUnexpected => 'Erro inesperado. Tente novamente em breve.';

  @override
  String get notFoundItems => 'Não foi encontrado itens.';

  @override
  String get readFileFailed => 'Falha ao ler o arquivo.';

  @override
  String get fileSystemException => 'Exceção do sistema de arquivos.';

  @override
  String get name => 'Nome';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get email => 'Email';

  @override
  String get password => 'Senha';

  @override
  String get btnLogin => 'Entrar';

  @override
  String get btnSignUp => 'Cadastrar';

  @override
  String get emailInUseError => 'Email já em uso.';
}
