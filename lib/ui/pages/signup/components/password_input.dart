import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:get/get.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.password,
            errorText: presenter.passwordError.value?.message,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
          onChanged: presenter.validatePassword,
        ));
  }
}
