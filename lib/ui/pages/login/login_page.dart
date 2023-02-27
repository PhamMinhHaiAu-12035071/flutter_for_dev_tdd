import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.presenter});

  final LoginPresenter? presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter?.mainErrorStream.listen((error) {
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
                child: Provider(
                  create: (_) => widget.presenter,
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
