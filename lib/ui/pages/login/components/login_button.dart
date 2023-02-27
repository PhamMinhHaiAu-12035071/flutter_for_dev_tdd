import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<LoginPresenter>();
    return StreamBuilder<bool?>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true
                ? presenter.auth
                : null,
            child: const Text('Login'),
          );
        });
  }
}
