import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<LoginPresenter>();
    return StreamBuilder<String?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
