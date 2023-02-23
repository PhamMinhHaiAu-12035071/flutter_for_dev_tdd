import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'For Dev',
      home: LoginPage(),
    );
  }
}
