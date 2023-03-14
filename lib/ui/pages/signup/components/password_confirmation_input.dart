import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.confirmPassword,
        errorText: null,
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      obscureText: true,
      onChanged: null,
    );
  }
}
