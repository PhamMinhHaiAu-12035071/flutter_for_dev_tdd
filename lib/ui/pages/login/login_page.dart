import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.presenter});

  final LoginPresenter? presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return SimpleDialog(
                  children: <Widget>[
                    Column(
                      children: const <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading', textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                );
              },
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });

        widget.presenter?.mainErrorStream.listen((error) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error, textAlign: TextAlign.center),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        return SingleChildScrollView(
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
                          stream: widget.presenter?.emailErrorStream,
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
                              onChanged: widget.presenter?.validateEmail,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: StreamBuilder<String?>(
                            stream: widget.presenter?.passwordErrorStream,
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
                                onChanged: widget.presenter?.validatePassword,
                              );
                            }),
                      ),
                      StreamBuilder<bool?>(
                          stream: widget.presenter?.isFormValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.data == true
                                  ? widget.presenter?.auth
                                  : null,
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
        );
      }),
    );
  }
}
