import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.presenter});

  final LoginPresenter? presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const LoginHeader(),
            const DisplayLarge(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: <Widget>[
                    StreamBuilder<String?>(
                        stream: presenter?.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter?.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: StreamBuilder<String?>(
                          stream: presenter?.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              obscureText: true,
                              onChanged: presenter?.validatePassword,
                            );
                          }),
                    ),
                    StreamBuilder<bool?>(
                        stream: presenter?.isFormValidStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.data == true ? () {} : null,
                            child: const Text('Login'),
                          );
                        }),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
