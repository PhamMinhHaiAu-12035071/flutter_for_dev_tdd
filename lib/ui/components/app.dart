import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_for_dev_tdd/main/factories/factories.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'For Dev',
      theme: makeAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fadeIn),
        GetPage(
            name: '/login',
            page: makeCubitLoginPage,
            transition: Transition.fadeIn),
        GetPage(
            name: '/surveys',
            page: () => const Scaffold(body: Text('Surveys'))),
      ],
    );
  }
}
