import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:get/get.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return Obx(() => ElevatedButton(
          onPressed:
              presenter.isFormValid.value == true ? presenter.auth : null,
          child: Text(R.strings.btnLogin),
        ));
  }
}
