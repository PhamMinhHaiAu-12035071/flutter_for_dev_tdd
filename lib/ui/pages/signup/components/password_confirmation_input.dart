import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/domain_exception.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:provider/provider.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<SignUpPresenter>();

    return StreamBuilder<DomainException?>(
        stream: null,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.strings.confirmPassword,
              errorText: snapshot.data?.message,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation,
          );
        });
  }
}
