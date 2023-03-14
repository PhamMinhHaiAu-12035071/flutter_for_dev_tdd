import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:get/get.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.confirmPassword,
            errorText: presenter.passwordConfirmationError.value?.message,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
          onChanged: presenter.validatePasswordConfirmation,
        ));
  }
}