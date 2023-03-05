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
  String get writeFileFailed => 'Falha ao escrever o arquivo.';
}
