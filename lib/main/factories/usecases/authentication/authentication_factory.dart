import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/authentication.dart';
import 'package:flutter_for_dev_tdd/main/factories/factories.dart';

Authentication makeRemoteAuthentication() {
  final url = makeApiUrl('login');
  final httpClient = makeHttpAdapter();
  return RemoteAuthentication(httpClient: httpClient, url: url);
}
