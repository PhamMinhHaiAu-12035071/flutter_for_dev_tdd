import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        errorText: null,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      keyboardType: TextInputType.name,
      onChanged: null,
    );
  }
}
