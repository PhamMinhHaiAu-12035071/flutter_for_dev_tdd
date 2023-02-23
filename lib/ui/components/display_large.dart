import 'package:flutter/material.dart';

class DisplayLarge extends StatelessWidget {
  final String text;
  const DisplayLarge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Login'.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge);
  }
}
