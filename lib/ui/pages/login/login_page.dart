import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.presenter});

  final LoginPresenter? presenter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: Scaffold(
        body: Builder(builder: (context) {
          presenter?.isLoading.listen((isLoading) {
            if (isLoading == true) {
              showLoading();
            } else {
              hideLoading(context);
            }
          });

          presenter?.mainError.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const LoginHeader(),
                const DisplayLarge(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        const EmailInput(),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordInput(),
                        ),
                        const LoginButton(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person),
                          label: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
