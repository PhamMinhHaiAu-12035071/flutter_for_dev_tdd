import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Fake')),
        body: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}

void main() {
  Future<void> loadPage(tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
      ],
    ));
  }

  testWidgets('Should present spinner on load page', (tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
