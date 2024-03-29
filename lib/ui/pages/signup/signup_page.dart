import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/ui/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/signup/components/components.dart';
import 'package:flutter_for_dev_tdd/ui/pages/signup/signup.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.presenter});

  final SignUpPresenter presenter;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: Scaffold(
        body: Builder(builder: (context) {
          widget.presenter.isLoading.listen((isLoading) {
            if (isLoading == true) {
              showLoading();
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.mainError.listen((DomainException? error) {
            if (error != null) {
              showErrorMessage(context, error.message);
            }
          });

          widget.presenter.navigateTo.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page!);
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
                  child: StreamProvider<SignUpPresenter>.value(
                    initialData: widget.presenter,
                    value: Stream<SignUpPresenter>.value(widget.presenter),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          const NameInput(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          const PasswordInput(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordConfirmationInput(),
                          ),
                          const SignUpButton(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.exit_to_app),
                            label: Text(R.strings.addAccount),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
