import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:get/get.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            errorText: presenter.nameError.value?.message,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
        ));
  }
}
