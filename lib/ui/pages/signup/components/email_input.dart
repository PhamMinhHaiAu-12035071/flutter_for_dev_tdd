import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: null,
        icon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: null,
    );
  }
}
