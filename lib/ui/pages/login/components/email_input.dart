import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:get/get.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: presenter.emailError.isEmpty == true
                ? null
                : presenter.emailError.value,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        ));
  }
}
