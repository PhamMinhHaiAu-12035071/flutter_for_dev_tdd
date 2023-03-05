import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:get/get.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: presenter.passwordError.value?.message ??
                presenter.passwordError.value?.message,
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
