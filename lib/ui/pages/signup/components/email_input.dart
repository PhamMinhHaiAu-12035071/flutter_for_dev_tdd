import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/domain_exception.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<SignUpPresenter>();
    return StreamBuilder<DomainException?>(
        stream: presenter.emailError,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.strings.email,
              errorText: snapshot.data?.message,
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
